#!/usr/bin/perl -w
use strict;
use warnings;
use lib '.';
use DictyRESTBuilder;

my $builder = DictyRESTBuilder->new(
    module_name  => 'DictyREST',
    license      => 'perl',
    dist_author  => 'Siddhartha Basu <siddhartha-basu@northwestern.edu>',
    dist_version => '1.2.0',
    requires     => {
        'Mojolicious'                          => '0.999938',
        'Plack'                                => '0.9941',
        'YAML::XS'                             => '0.33',
        'Module::Versions'                     => '0.02',
        'FCGI::Engine'                         => '0.16',
        'Homology::Group'                      => '',
        'dicty::Tests::Data'                   => '',
        'dicty::Feature'                       => '',
        'dicty::UI::Tabview::Page::Gene'       => '',
        'Mojolicious::Plugin::Modware::Oracle' => '',
        'Mojolicious::Plugin::AssetTagHelpers' => '',
        'Mojolicious::Plugin::DictyGene'       => '',
        'Mojolicious::Plugin::YmlConfig'       => ''
    },
    add_to_cleanup => [' DictyREST- *'],
    create_readme  => 1,
);

$builder->create_build_script();

