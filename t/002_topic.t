#!perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use FindBin;
use Data::Dumper;
use Test::Mojo;
use lib "$FindBin::Bin/lib";

use_ok('DictyGene');

my $client = Test::Mojo->new( app => 'DictyGene' );

#request for gene
my $tx = $client->get_ok('/gene/DDB_G0288511/gene.json');
$tx->status_is( 200, 'is a successful response for gene' );
$tx->content_type_like( qr/json/, 'is a json content for gene' );
$tx->content_like( qr/layout.+accordion/,
    'has a accordion layout in json content' );

#request for phenotypes
$tx = $client->get_ok('/gene/DDB_G0288511/phenotypes');
$tx->status_is( 200, 'is a successful response for phenotypes' );
$tx->content_type_like( qr/html/, 'is a json content for phenotype' );
$tx->content_like( qr/Gene page for sadA/i,
    'is the title with phenotype tab selected' );
$tx->content_like( qr/Supported by NIH/i,
    'is the common footer for every gene page' );

#request for phenotypes
$tx = $client->get_ok('/gene/DDB_G0288511/phenotypes.json');
$tx->status_is( 200, 'is a successful response for phenotypes' );
$tx->content_type_like( qr/json/, 'is a json content for phenotype' );
$tx->content_like( qr/layout.+row/,
    'has a row layout in json content for phenotype' );

#request for gene
$tx = $client->get_ok('/gene/DDB_G0286355/gene.json');
$tx->status_is( 200, 'is a successful response for mhcA gene' );
$tx->content_type_like( qr/json/, 'is a json content for gene' );
$tx->content_like( qr/layout.+accordion/,
    'has a accordion layout in json content' );

SKIP: {

    skip 'skipping until we load reference text fixtures in chado schema';

    #request for references
    $tx = $client->get_ok('/gene/DDB_G0288511/references');
    $tx->status_is( 200, 'is a successful response for references' );
    $tx->content_type_like( qr/html/, 'is a html content for references' );
    $tx->content_like( qr/Gene page for sadA/i,
        'is the title with reference tab selected' );
    $tx->content_like( qr/Supported by NIH/i,
        'is the common footer for every gene page' );

    #request for references
    $tx = $client->get_ok('/gene/DDB_G0288511/references.json');
    $tx->status_is( 200, 'is a successful response for references' );
    $tx->content_type_like( qr/json/, 'is a json content for references' );
    $tx->content_like( qr/layout.+column/,
        'has a column layout in json content' );

    #default request for references with gene name
    $tx = $client->get_ok('/gene/sadA/references');
    $tx->status_is( 200, 'is a successful response for references' );
    $tx->content_type_like( qr/html/, 'is a html content for references' );
    $tx->content_like( qr/Gene page for sadA/i,
        'is the title with reference tab selected' );

    #request for references with gene name
    $tx = $client->get_ok('/gene/sadA/references.json');
    $tx->status_is( 200, 'is a successful response for references' );
    $tx->content_type_like( qr/json/, 'is a json content for references' );
    $tx->content_like( qr/layout.+column/,
        'has a column layout in json content' );

}

