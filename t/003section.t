#!perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/lib";

use_ok('DictyGene');

my $client = Test::Mojo->new( app => 'DictyGene' );

#request for section info under default gene topic
my $tx = $client->get_ok('/gene/DDB_G0288511/gene/info.json');
$tx->status_is( 200, 'is a successful response for info section' );
$tx->content_type_like( qr/json/, 'is a json content for info' );
$tx->content_like( qr/layout.+row/, 'has a row layout in info' );

#request for section sequences under default gene topic
$tx = $client->get_ok('/gene/DDB_G0288511/gene/sequences.json');
$tx->status_is( 200, 'is a successful response for sequences section' );
$tx->content_type_like( qr/json/, 'is a json content for sequences' );
$tx->content_like( qr/layout.+row/, 'has a row layout in sequences' );

#request for section links under default gene topic
$tx = $client->get_ok('/gene/DDB_G0288511/gene/links.json');
$tx->status_is( 200, 'is a successful response for links section' );
$tx->content_type_like( qr/json/, 'is a json content for links' );
$tx->content_like( qr/layout.+row/, 'has a row layout in links' );

#request for summary section under default gene topic
$tx = $client->get_ok('/gene/DDB_G0288511/gene/summary.json');
$tx->status_is( 200,
    'is a successful response for summary section with explicit json format'
);
$tx->content_type_like( qr/json/, 'is a json content for summary' );
$tx->content_like( qr/layout.+row/, 'has a row layout in summary' );

#request for feature tab
$tx = $client->get_ok('/gene/DDB_G0288511/feature/DDB0191090');
$tx->status_is( 200, 'is a successful response for feature section' );
$tx->content_type_like( qr/html/, 'is a html content for feature' );
$tx->content_like( qr/Gene page for sadA/i,
    'is the title for sadA gene page' );

#request for feature tab
$tx = $client->get_ok('/gene/DDB_G0288511/feature');
$tx->status_is( 200, 'is a successful response for feature section' );

#request for feature tab
$tx = $client->get_ok('/gene/DDB_G0288511/feature/DDB0191090');
$tx->status_is( 200, 'is a successful response for feature section' );
$tx->content_type_like( qr/html/, 'is a html content for feature' );
$tx->content_like( qr/Gene page for sadA/i,
    'is the title for sadA gene page' );

#request for feature tab
$tx = $client->get_ok('/gene/DDB_G0288511/feature');
$tx->status_is( 200, 'is a successful response for feature section' );

#request for section sequence under protein topic with explicit json requirement
$tx = $client->get_ok('/gene/DDB_G0288511/protein/DDB0191090/sequence.json');
$tx->status_is( 200,
    'is a successful json response for protein info sequence' );
$tx->content_type_like( qr/json/, 'is a json content for protein sequence' );
$tx->content_like( qr/layout.+row/, 'has a row layout in protein sequence' );

#request for section info under protein topic
$tx = $client->get_ok('/gene/DDB_G0288511/protein/DDB0191090/info');
$tx->status_is( 200, 'is a successful response for protein info section' );
$tx->content_type_like( qr/json/, 'is a json content for protein info' );
$tx->content_like( qr/layout.+row/, 'has a row layout in protein links' );

#request for section sequence under protein topic
$tx = $client->get_ok('/gene/DDB_G0288511/protein/DDB0191090/sequence');
$tx->status_is( 200, 'is a successful response for protein info sequence' );
$tx->content_type_like( qr/json/, 'is a json content for protein sequence' );
$tx->content_like( qr/layout.+row/, 'has a row layout in protein sequence' );

SKIP: {

    skip 'until we load go test fixtures in chado schema';

    #request for function section under GO topic
    $tx = $client->get_ok('/gene/DDB_G0288511/go/function.json');
    $tx->status_is( 200,
        'is a successful response for function section under GO' );
    $tx->content_type_like( qr/json/, 'is a json content for function' );
    $tx->content_like( qr/layout.+json/, 'has a json layout in function' );

    #request for component section under GO topic
    $tx = $client->get_ok('/gene/DDB_G0288511/go/component.json');
    $tx->status_is( 200,
        'is a successful response for component section under GO' );
    $tx->content_type_like( qr/json/, 'is a json content for component' );
    $tx->content_like( qr/layout.+json/, 'has a json layout in componet' );

}
