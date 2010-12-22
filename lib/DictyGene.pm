package DictyGene;

use strict;
use base 'Mojolicious';
use Homology::Chado::DataSource;

# This will run once at startup
sub startup {
    my ($self) = @_;

    $self->plugin('yml_config');
    $self->plugin('modware-oracle');
    $self->plugin('asset_tag_helpers');

    if ( defined $self->config->{cache} ) {
        ## -- add the new cache plugin
    }
    $self->plugin('dicty_gene');

    my $router = $self->routes();

    #routing setup
    my $bridge
        = $router->bridge('/gene')->to('controller-input#check_for_redirect');
    $bridge->route('/:id')->via('get')->to('controller-page#index');
    $bridge->route('/:id/:tab')->via('get')
        ->to( 'controller-page#tab', format => 'html' );
    $bridge->route('/:id/:tab/:section')->via('get')
        ->to( 'controller-tab#section', format => 'html' );
    $bridge->route('/:id/:tab/:subid/:section')->via('get')
        ->to( 'controller-tab#sub_section', format => 'json' );

    ## init database connection
    my $datasource = Homology::Chado::DataSource->instance;
    $datasource->dsn( $self->config->{database}->{dsn} )
        if !$datasource->has_dsn;
    $datasource->user( $self->config->{database}->{user} )
        if !$datasource->has_user;
    $datasource->password( $self->config->{database}->{password} )
        if !$datasource->has_password;

}

1;
__END__

=head1 NAME

DictyGene - Web Framework

=head1 SYNOPSIS

    use base 'DictyGene';

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
