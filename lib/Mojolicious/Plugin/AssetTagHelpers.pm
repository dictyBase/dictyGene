package Mojolicious::Plugin::AssetTagHelpers;

use strict;

# Other modules:
use base qw/Mojolicious::Plugin/;
use Mojo::ByteStream;
use Regexp::Common qw/URI/;
use Mojo::Client;
use HTTP::Date;
use File::stat;
use File::Spec::Functions;
use File::Basename;

# Module implementation
#

__PACKAGE__->attr('asset_dir');
__PACKAGE__->attr('asset_host');
__PACKAGE__->attr('relative_url_root');
__PACKAGE__->attr( 'javascript_dir' => '/javascripts' );
__PACKAGE__->attr( 'stylesheet_dir' => '/stylesheets' );
__PACKAGE__->attr( 'image_dir'      => '/images' );
__PACKAGE__->attr( 'javascript_ext' => '.js' );
__PACKAGE__->attr( 'stylesheet_ext' => '.css' );
__PACKAGE__->attr(
    'image_options' => sub { [qw/width height class id border/] } );
__PACKAGE__->attr('app');
__PACKAGE__->attr( 'true' => 1 );

sub register {
    my ( $self, $app, $conf ) = @_;
    $self->asset_dir( $app->static->root );
    $self->app($app);
    if ( my $url = $self->compute_relative_url( @_[ 1, -1 ] ) ) {
        $self->relative_url_root($url);
        $app->log->debug("relative url root: $url");

# -- in case of non-default value strip off the name before serving the assets
        $app->static->prefix($url);
    }
    if ( my $host = $self->compute_asset_host( @_[ 1, -1 ] ) ) {
        $self->asset_host($host);
    }

    # -- image tag
    $app->helper(
        image_tag => sub {
            my ( $c, $name, %options ) = @_;
            my $tags;
            if (%options) {
                if ( defined $options{size} ) {
                    $tags = qq/height="$options{size} width="$options{size}"/;
                }
                if ( defined $options{alt} ) {
                    $tags .= qq/alt="$options{alt}"/;
                }
                for my $opt_name ( @{ $self->image_options } ) {
                    $tags .= qq/$opt_name="$options{$opt_name}"/
                        if defined $options{$opt_name};
                }
            }
            else {
                my $alt_name = $self->compute_alt_name($name);
                $tags .= $tags .= qq/alt="$alt_name"/;
            }

            my $source = $self->compute_image_path( $name, $self->true );
            return Mojo::ByteStream->new(qq{<img src="$source" $tags/>});
        }
    );

    # -- javascript tag
    $app->helper(
        javascript_include_tag => sub {
            my ( $c, $name ) = @_;
            my $source = $self->compute_javascript_path( $name, $self->true );
            return Mojo::ByteStream->new(
                qq{<script src="$source" type="text/javascript"></script>});
        }
    );

    # -- stylesheet tag
    $app->helper(
        stylesheet_link_tag => sub {
            my ( $c, $name, %option ) = @_;
            my $source = $self->compute_stylesheet_path( $name, $self->true );
            my $media
                = $option{media}
                ? qq{media="$option{media}}
                : qq{media="screen"};

            return Mojo::ByteStream->new(
                qq{<link href="$source" $media rel="stylesheet" type="text/css" />}
            );
        }
    );

    $app->helper(
        'stylesheet_path' => sub {
            my ( $c, $path ) = @_;
            return Mojo::ByteStream->new(
                $self->compute_stylesheet_path($path) );
        }
    );

    $app->helper(
        'javascript_path' => sub {
            my ( $c, $path ) = @_;
            return Mojo::ByteStream->new(
                $self->compute_javascript_path($path) );
        }
    );

    $app->helper(
        'image_path' => sub {
            my ( $c, $path ) = @_;
            return Mojo::ByteStream->new( $self->compute_image_path($path) );
        }
    );
}

sub compute_relative_url {
    my ( $self, $app, $conf ) = @_;
    my $url;
    if ( $app->can('config') and defined $app->config->{relative_url_root} ) {
        $url = $app->config->{relative_url_root};
    }

    if ( defined $conf and defined $conf->{relative_url_root} ) {
        $url = $conf->{relative_url_root};
    }
    $url;
}

sub compute_asset_host {
    my ( $self, $app, $conf ) = @_;
    my $host;
    if ( $app->can('config') and defined $app->config->{asset_host} ) {
        $host = $app->config->{asset_host};
    }

    if ( defined $conf and defined $conf->{asset_host} ) {
        $host = $conf->{asset_host};
    }
    $host;
}

sub compute_alt_name {
    my ( $self, $name ) = @_;
    my $img_regexp = qr/^([^.]+)\.(jpg|png|gif)$/;
    if ( $name =~ $RE{URI}{HTTP} ) {
        my $img_name = basename $name;
        return ucfirst $1 if $img_name =~ $img_regexp;
        return ucfirst $img_name;
    }

    return ucfirst $1 if $name =~ $img_regexp;
    return ucfirst $name;
}

sub compute_asset_id {
    my ( $self, $file ) = @_;
    if ( $file =~ $RE{URI}{HTTP} ) {
        my $tx = Mojo::Client->new->head($file);
        if ( $tx->res->code == 200 ) {
            my $asset_id = str2time( $tx->res->headers->last_modified );
            return $asset_id;
        }
        return;
    }

    my $full_path = catfile( $self->asset_dir, $file );
    if ( -e $full_path ) {
        my $st = stat($full_path);
        return $st->mtime;
    }
}

sub compute_image_path {
    my ( $self, $name, $default ) = @_;
    my $image_path
        = $default
        ? $self->compute_asset_path( catfile( $self->image_dir, $name ) )
        : $self->compute_asset_dir($name);
    my $asset_id
        = $default
        ? $self->compute_asset_id( catfile( $self->image_dir, $name ) )
        : $self->compute_asset_id($name);

    return $image_path . '?' . $asset_id if $asset_id;
    $image_path;
}

sub compute_javascript_path {
    my ( $self, $name, $default ) = @_;
    my ( $js_path, $asset_id );
    if ( $name !~ $RE{URI}{HTTP} ) {
        $name = $name . $self->javascript_ext if $name !~ /\.js$/;
    }

    $js_path
        = $default
        ? $self->compute_asset_path( catfile( $self->javascript_dir, $name ) )
        : $self->compute_asset_path($name);
    $asset_id
        = $default
        ? $self->compute_asset_id( catfile( $self->javascript_dir, $name ) )
        : $self->compute_asset_id($name);

    return $js_path . '?' . $asset_id if $asset_id;
    $js_path;
}

sub compute_stylesheet_path {
    my ( $self, $name, $default ) = @_;
    my ( $css_path, $asset_id );
    if ( $name !~ $RE{URI}{HTTP} ) {
        $name = $name . $self->stylesheet_ext if $name !~ /\.css$/;
    }

    $css_path
        = $default
        ? $self->compute_asset_path( catfile( $self->stylesheet_dir, $name ) )
        : $self->compute_asset_path($name);

    $asset_id
        = $default
        ? $self->compute_asset_id( catfile( $self->stylesheet_dir, $name ) )
        : $self->compute_asset_id($name);

    return $css_path . '?' . $asset_id if $asset_id;
    $css_path;
}

sub compute_asset_path {
    my ( $self, $file ) = @_;
    return $file if $file =~ $RE{URI}{HTTP};    ## -- full http url
    my $path
        = $self->relative_url_root
        ? $self->relative_url_root . $file
        : $file;
    $path = $self->asset_host ? $self->asset_host . '/' . $path : $path;
    $path;
}

1;    # Magic true value required at end of module

__END__

=head1 NAME

B<Mojolicious::Plugin::AssetTagHelpers> - [Tag helpers for javascripts,images and
stylesheets]



=head1 SYNOPSIS


=for author to fill in:
Brief code example(s) here showing commonest usage(s).
This section will be as far as many users bother reading
so make it as educational and exeplary as possible.


=head1 DESCRIPTION

=for author to fill in:
Write a full description of the module and its features here.
Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=for author to fill in:
Write a separate section listing the public components of the modules
interface. These normally consist of either subroutines that may be
exported, or methods that may be called on objects belonging to the
classes provided by the module.

=head2 <METHOD NAME>

=over

=item B<Use:> <Usage>

[Detail text here]

=item B<Functions:> [What id does]

[Details if neccessary]

=item B<Return:> [Return type of value]

[Details]

=item B<Args:> [Arguments passed]

[Details]

=back

=head2 <METHOD NAME>

=over

=item B<Use:> <Usage>

[Detail text here]

=item B<Functions:> [What id does]

[Details if neccessary]

=item B<Return:> [Return type of value]

[Details]

=item B<Args:> [Arguments passed]

[Details]

=back


=head1 DIAGNOSTICS

=for author to fill in:
List every single error and warning message that the module can
generate (even the ones that will "never happen"), with a full
explanation of each problem, one or more likely causes, and any
suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
A full explanation of any configuration system(s) used by the
module, including the names and locations of any configuration
files, and the meaning of any environment variables or properties
that can be set. These descriptions must also include details of any
configuration language used.

<MODULE NAME> requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
A list of all the other modules that this module relies upon,
  including any restrictions on versions, and an indication whether
  the module is part of the standard Perl distribution, part of the
  module's distribution, or must be installed separately. ]

  None.


  =head1 INCOMPATIBILITIES

  =for author to fill in:
  A list of any modules that this module cannot be used in conjunction
  with. This may be due to name conflicts in the interface, or
  competition for system or program resources, or due to internal
  limitations of Perl (for example, many modules that use source code
		  filters are mutually incompatible).

  None reported.


  =head1 BUGS AND LIMITATIONS

  =for author to fill in:
  A list of known problems with the module, together with some
  indication Whether they are likely to be fixed in an upcoming
  release. Also a list of restrictions on the features the module
  does provide: data types that cannot be handled, performance issues
  and the circumstances in which they may arise, practical
  limitations on the size of data sets, special cases that are not
  (yet) handled, etc.

  No bugs have been reported.Please report any bugs or feature requests to
  dictybase@northwestern.edu



  =head1 TODO

  =over

  =item *

  [Write stuff here]

  =item *

  [Write stuff here]

  =back


  =head1 AUTHOR

  I<Siddhartha Basu>  B<siddhartha-basu@northwestern.edu>


  =head1 LICENCE AND COPYRIGHT

  Copyright (c) B<2003>, Siddhartha Basu C<<siddhartha-basu@northwestern.edu>>. All rights reserved.

  This module is free software; you can redistribute it and/or
  modify it under the same terms as Perl itself. See L<perlartistic>.


  =head1 DISCLAIMER OF WARRANTY

  BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
  FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
  OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
  PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
  EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
  ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
  YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
  NECESSARY SERVICING, REPAIR, OR CORRECTION.

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
  WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
  REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
  LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
  OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
  THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
		  RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
		  FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
  SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGES.



