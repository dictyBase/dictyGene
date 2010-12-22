package DictyGene::Controller::Tab;

use strict;
use base qw/DictyGene::Controller::Input/;
use dicty::UI::Tabview::Page::Gene;
use dicty::Factory::Tabview::Tab;
use dicty::Factory::Tabview::Section;

sub section {
    my ($self) = @_;
    return if !$self->check_input;
    my $method = 'section_' . $self->stash('format');
    $self->$method();
}

sub section_html {
    my ($self) = @_;

    my $gene_id = $self->stash('gene_id');
    my $tab     = $self->stash('tab');
    my $section = $self->stash('section');
    my $app     = $self->app;

    if ( $app->config->{tab}->{dynamic} eq $tab ) {
        my $db = dicty::UI::Tabview::Page::Gene->new(
            -primary_id => $gene_id,
            -active_tab => $tab,
            -sub_id     => $section,
            -base_url   => $self->stash('base_url')
        );
        $self->stash( $db->result() );

        #force formatter
        $self->render('index');
    }
}

sub section_json {
    my ($self) = @_;

    my $gene_id = $self->stash('gene_id');
    my $tab     = $self->stash('tab');
    my $section = $self->stash('section');
    my $app     = $self->app;

    my $factory;
    if ( $self->is_ddb($section) ) {
        $factory = dicty::Factory::Tabview::Tab->new(
            -tab        => $tab,
            -primary_id => $section,
            -base_url   => $self->stash('base_url')
        );
    }
    else {

        $factory = dicty::Factory::Tabview::Section->new(
            -tab        => $tab,
            -primary_id => $gene_id,
            -section    => $section,
            -base_url   => $self->stash('base_url')
        );
    }

    my $obj = $factory->instantiate;
    $obj->init();
    my $conf = $obj->config();
    $self->render_json( [ map { $_->to_json } @{ $conf->panels } ] );

}

sub sub_section {
    my ($self) = @_;
    return if !$self->check_input;

    my $factory = dicty::Factory::Tabview::Section->new(
        -primary_id => $self->stash('subid'),
        -section    => $self->stash('section'),
        -tab        => $self->stash('tab'),
        -base_url   => $self->stash('base_url')
    );

    my $obj = $factory->instantiate;
    $obj->init();
    my $conf = $obj->config();
    $self->render_json( [ map { $_->to_json } @{ $conf->panels } ] );
}

1;

