package DictyREST;

use strict;
use warnings;

use base 'Mojolicious';
use Config::Simple;
use Carp;
use File::Spec::Functions;
use Bio::Chado::Schema;
use DictyREST::Renderer::TT;
use DictyREST::Renderer::JSON;
use DictyREST::Helper;
use Homology::Chado::DataSource;
use CHI;

__PACKAGE__->attr( 'config' => sub { Config::Simple->new() } );
__PACKAGE__->attr('template_path');
__PACKAGE__->attr( 'has_config' => 0 );
__PACKAGE__->attr( 'helper' => sub { DictyREST::Helper->new() } );
__PACKAGE__->attr('prefix');
__PACKAGE__->attr('model');
__PACKAGE__->attr('cache');

# This will run once at startup
sub startup {
    my ($self) = @_;

    #default log level
    my $router = $self->routes();

    #$self->log->debug("starting up");
    #config file setup
    $self->set_config();

    if ( $self->config->param('cache.driver') ) {
    	$self->log->debug('adding cache plugin');
    	$self->log->debug('cache expires in '.$self->config->param('cache.expires_in'));

        $self->cache(
            CHI->new(
                driver     => $self->config->param('cache.driver'),
                root_dir   => $self->config->param('cache.root'),
                depth      => $self->config->param('cache.depth'),
                namespace  => $self->config->param('cache.namespace'),
                expires_in => $self->config->param('cache.expires_in')
            )
        );

        #plugins
        $self->plugin(
            'actioncache',
            {   debug         => 1,
                cache_object  => $self->cache,
                cache_actions => [qw/index index_html index_json tab section sub_section/]
            }
        );
    }

    #routing setup
    my $base = $router->namespace();
    $router->namespace( $base . '::Controller' );

    #$self->log->debug($base);

    my $bridge = $router->bridge('/gene')->to(
        controller => 'input',
        action     => 'check_for_redirect'
    );
    $bridge->route('/:id')
        ->to( controller => 'page', action => 'index');

    $bridge->route('/:id/:tab')->via('get')->to(
        controller => 'page',
        action     => 'tab',
        format     => 'html'
    );

    $bridge->route('/:id/:tab/:section')->via('get')
        ->to( controller => 'tab', action => 'section', format => 'html' );

    $bridge->route('/:id/:tab/:subid/:section')->via('get')->to(
        controller => 'tab',
        action     => 'sub_section',
        format     => 'json'
    );

    #set up various renderer
    $self->set_renderer();
    $self->helper->app($self);
    $self->set_dbh;

    ## init database connection
    my $datasource = Homology::Chado::DataSource->instance;
    $datasource->dsn( $self->config->param('database.dsn') )
        if !$datasource->has_dsn;
    $datasource->user( $self->config->param('database.user') )
        if !$datasource->has_user;
    $datasource->password( $self->config->param('database.pass') )
        if !$datasource->has_password;

    $self->log->debug("done with startup");
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

    opendir my $conf, $folder or confess "cannot open folder $!:$folder";
    my ($file) = grep {/$suffix$/} readdir $conf;
    closedir $conf;

    $self->log->debug(qq/got config file $file/);
    $self->log->debug($self->home->to_string);
    $self->log->debug($self->home->app_class);
    $self->config->read( catfile( $folder, $file ) );
    $self->has_config(1);

    my $prefix_has = {
        map { $_ => 1 } split /:/,
        $self->config->param('multigenome.prefix_list')
    };
    $self->prefix($prefix_has);

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
        path => $self->template_path,

        #compile_dir => $compile_dir,
        option => {
            PRE_PROCESS  => $self->config->param('genepage.header') || '',
            POST_PROCESS => $self->config->param('genepage.footer') || '',
        },
    );
    my $json = DictyREST::Renderer::JSON->new();
    $self->renderer->add_handler(
        tt   => $tt->build(),
        json => $json->build(),
    );
    $self->renderer->default_handler('tt');
}

sub set_dbh {
    my $self   = shift;
    my $opt    = $self->config->param('database.opt');
    my $schema = Bio::Chado::Schema->connect(
        $self->config->param('database.dsn'),
        $self->config->param('database.user'),
        $self->config->param('database.pass'),
        { $opt => 1 }
    );
    $self->model($schema);
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
