#!/usr/bin/perl -w
use strict;
use warnings;
use lib 'lib';
use DictyGene::Builder;

my $builder = DictyGene::Builder->new(
    module_name  => 'DictyGene',
    license      => 'perl',
    dist_author  => 'Siddhartha Basu <siddhartha-basu@northwestern.edu>',
    dist_version => '0.001',
    requires     => {
        'Mojolicious'            => '0.999938',
        'Plack'                          => '0.9941',
        'Module::Versions'               => '0.02',
        'FCGI::Engine'                   => '0.16',
        'Homology::Chado::DataSource'    => '0.01',
        'Modware'                        => '0.001',
        'Mojolicious::Plugin::Bundle'    => '0.001',
        'Mojolicious::Plugin::Cache'     => '0.0011',
        'dicty::Tests::Data'             => '',
        'dicty::Feature'                 => '',
        'dicty::UI::Tabview::Page::Gene' => '',
    },
    configure_requires => {
        'Path::Class'  => '0.23',
        'Try::Tiny'    => '0.09',
        'TAP::Harness' => '3.22',
    },
    add_to_cleanup => ['DictyGene- *'],
    create_readme  => 1,
);

$builder->create_build_script();

