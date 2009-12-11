package GenomeREST;

use strict;
use warnings;

use base 'Mojolicious';
use Config::Simple;
use Carp;
use File::Spec::Functions;
use DictyREST::Renderer::TT;
use DictyREST::Renderer::JSON;
use DictyREST::Renderer::JSON_Generic;
use DictyREST::Helper;

__PACKAGE__->attr( 'config', default => sub { Config::Simple->new() } );
__PACKAGE__->attr('template_path');
__PACKAGE__->attr( 'has_config', default => 0 );
__PACKAGE__->attr( 'helper', default => sub { DictyREST::Helper->new() } );

# This will run once at startup
sub startup {
    my ($self) = @_;

    #default log level
    $self->log->level('debug');

    #config file setup
    $self->set_config();

    my $router = $self->routes();

    #$self->log->debug("starting up");


    #reusing DictyREST controller
    $router->namespace( 'DictyREST::Controller' );

    #routing setup
    #goes here before it passes to any other controller
    #kind of before action
    #suffix based routing for multigenome setup
    my $bridge = $router->bridge('/:species/gene')->to(
            controller => 'input',
            action     => 'validate_species'
        );

    #support both json and html
    #default is html
    $bridge->route('/:id')
        ->to( controller => 'page', action => 'index', format => 'html' );

    #default is html
    $bridge->route('/:id/:tab')
        ->to( controller => 'page', action => 'tab', format => 'html' );

#keeping the default to html as it is needed for feature tab
#this is the only url that is being called without any extension and gives back html
    $bridge->route('/:id/:tab/:section')
        ->to( controller => 'tab', action => 'section', format => 'html' );

    #only support json response
    $bridge->route('/:id/:tab/:subid/:section')->to(
        controller => 'tab',
        action     => 'sub_section',
        format     => 'json'
    );

    #organisms
    $router->route('/organism')
        ->to( controller => 'organism', action => 'index', format => 'json' );

    #set up various renderer
    $self->set_renderer();

    #$self->log->debug("done with startup");
}

#set up config file usually look under conf folder
#supports similar profile as log file
sub set_config {
    my ( $self, $c ) = @_;
    my $folder = $self->home->rel_dir('conf');
    if ( !-e $folder ) {
        return;
    }

    #$self->log->debug(qq/got folder $folder/);

#now the file name,  default which is developmental mode resolves to <name>.conf. For
#test and production it will be <name>.test.conf and <name>.production.conf respectively.
    my $mode   = $self->mode();
    my $suffix = '.conf';
    if ( $mode eq 'production' or $mode eq 'test' ) {
        $suffix = '.' . $mode . '.conf';
    }
    my $app_name = lc $self->home->app_class;

    #opendir my $conf, $folder or confess "cannot open folder $!:$folder";
    #my $file = catfile()
    #closedir $conf;

    my $file = catfile( $folder, $app_name . $suffix );
    $self->log->debug(qq/got config file $file/);
    $self->config->read($file);
    $self->has_config(1);

}

sub set_renderer {
    my ($self) = @_;

    #try to set the default template path for TT
    #keep in mind this setup is separate from the Mojo's default template path
    #if something not specifically is not set it defaults to Mojo's default
    $self->template_path( $self->renderer->root );
    if ( $self->has_config and $self->config->param('default.template_path') )
    {
        $self->template_path( $self->config->param('default.template_path') );
    }

    my $tpath = $self->template_path;

    $self->log->debug(qq/default template path for TT $tpath/);

    my $mode        = $self->mode();
    my $compile_dir = $self->home->rel_dir('tmp');
    if ( $mode eq 'production' or $mode eq 'test' ) {
        $compile_dir = $self->home->rel_dir('webtmp');
    }
    $self->log->debug(qq/default compile path for TT $compile_dir/);
    if ( !-e $compile_dir ) {
        $self->log->error("folder for template compilation is absent");
    }

    my $tt = DictyREST::Renderer::TT->new(
        path        => $self->template_path,
        compile_dir => $compile_dir,
        option      => {
            PRE_PROCESS  => $self->config->param('genepage.header') || '',
            POST_PROCESS => $self->config->param('genepage.footer') || '',
        },
    );
    my $json         = DictyREST::Renderer::JSON->new();
    my $json_generic = DictyREST::Renderer::JSON_Generic->new();

    $self->renderer->add_handler(
        tt           => $tt->build(),
        json         => $json->build(),
        json_generic => $json_generic->build()
    );
    $self->renderer->default_handler('tt');
}

1;
__END__

=head1 NAME

DictyREST - Web Framework

=head1 SYNOPSIS

    use base 'DictyREST';

    sub startup {
        my $self = shift;

        my $r = $self->routes;

        $r->route('/:controller/:action')
          ->to(controller => 'foo', action => 'bar');
    }

=head1 DESCRIPTION

L<Mojolicous> is a web framework built upon L<Mojo>.

See L<Mojo::Manual::DictyREST> for user friendly documentation.

=head1 ATTRIBUTES

L<DictyREST> inherits all attributes from L<Mojo> and implements the
following new ones.

=head2 C<mode>

    my $mode = $mojo->mode;
    $mojo    = $mojo->mode('production');

Returns the current mode if called without arguments.
Returns the invocant if called with arguments.
Defaults to C<$ENV{MOJO_MODE}> or C<development>.

    my $mode = $mojo->mode;
    if ($mode =~ m/^dev/) {
        do_debug_output();
    }

=head2 C<renderer>

    my $renderer = $mojo->renderer;
    $mojo        = $mojo->renderer(DictyREST::Renderer->new);

=head2 C<routes>

    my $routes = $mojo->routes;
    $mojo      = $mojo->routes(DictyREST::Dispatcher->new);

=head2 C<static>

    my $static = $mojo->static;
    $mojo      = $mojo->static(MojoX::Dispatcher::Static->new);

=head2 C<types>

    my $types = $mojo->types;
    $mojo     = $mojo->types(MojoX::Types->new)

=head1 METHODS

L<DictyREST> inherits all methods from L<Mojo> and implements the following
new ones.

=head2 C<new>

    my $mojo = DictyREST->new;

Returns a new L<DictyREST> object.
This method will call the method C<${mode}_mode> if it exists.
(C<$mode> being the value of the attribute C<mode>).
For example in production mode, C<production_mode> will be called.

=head2 C<build_ctx>

    my $c = $mojo->build_ctx($tx);

=head2 C<dispatch>

    $mojo->dispatch($c);

=head2 C<handler>

    $tx = $mojo->handler($tx);

=head2 C<startup>

    $mojo->startup($tx);

=cut