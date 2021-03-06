package DictyGene::Controller::Page;

use strict;
use base qw/DictyGene::Controller::Input/;
use dicty::UI::Tabview::Page::Gene;
use dicty::Factory::Tabview::Tab;
use dicty::Factory::Tabview::Section;

sub index {
    my ($self) = @_;
    return if !$self->check_input;

    #partial hack have to figure out something better later on
    my $format = $self->stash('format') || 'html';
    my $method = 'index_' . $format;
    $self->$method();
}

sub index_html {
    my ($self) = @_;
    my $app = $self->app;

    #database query
    my $db = dicty::UI::Tabview::Page::Gene->new(
        -primary_id => $self->stash('gene_id'),
        -active_tab => 'gene',
        -base_url   => $self->url_for('gene'),
        -context    => $self
    );

    $app->log->debug( $self->url_for('gene') );

    #$app->log->debug($self->dumper($db->result));
    #default rendering
    $self->stash( $db->result() );
    $self->render('index');
}

sub index_json {
    my ($self) = @_;

    my $factory = dicty::Factory::Tabview::Tab->new(
        -tab        => 'gene',
        -primary_id => $self->stash('gene_id'),
    );

    my $obj = $factory->instantiate;

    #routine to get perl data structure that will be converted to json
    $obj->init();
    my $conf = $obj->config();
    $self->render_json( [ map { $_->to_json } @{ $conf->panels } ] );

}

sub tab {
    my ($self) = @_;
    return if !$self->check_input;
    my $method = 'tab_' . $self->stash('format');
    $self->$method();
}

sub tab_html {
    my ($self)  = @_;
    my $app     = $self->app;
    my $gene_id = $self->stash('gene_id');
    my $tab     = $self->stash('tab');

    my $db;
    if ( $app->config->{tab}->{dynamic} eq $tab ) {

        #convert gene id to its primary DDB id
        my $trans_id = $self->transcript_id($gene_id);
        if ( !$trans_id ) {    #do some octocat based template here
            return;
        }
        $db = dicty::UI::Tabview::Page::Gene->new(
            -primary_id => $gene_id,
            -active_tab => $tab,
            -context    => $self,
            -base_url   => $self->stash('base_url'),
            -sub_id     => $trans_id,
        );
    }
    else {
        $db = dicty::UI::Tabview::Page::Gene->new(
            -primary_id => $gene_id,
            -active_tab => $tab,
            -base_url   => $self->url_for('gene'),
            -context    => $self
        );
    }

    #result
    $self->stash( $db->result() );
    $self->render('index');
}

sub tab_json {
    my ($self) = @_;
    my $factory = dicty::Factory::Tabview::Tab->new(
        -tab        => $self->stash('tab'),
        -primary_id => $self->stash('gene_id'),
        -base_url   => $self->url_for('gene'),
        -context    => $self
    );
    my $obj = $factory->instantiate;

    #routine to get perl data structure that will be converted to json
    $obj->init();
    my $conf = $obj->config();
    $self->render_json( [ map { $_->to_json } @{ $conf->panels } ] );
}

1;

