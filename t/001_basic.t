use strict;
use warnings;

use Test::More qw/no_plan/;
use Test::Mojo;
use FindBin;
use lib "$FindBin::Bin/lib";

BEGIN { $ENV{MOJO_MODE} ||= 'test' }

use_ok('DictyGene');

my $name  = 'test_CURATED';
my $mt    = Test::Mojo->new( app => 'DictyGene' );
my $model = $mt->app->modware->handler;

my $gene_row
    = $model->resultset('Sequence::Feature')->find( { uniquename => $name } );
if ( !$gene_row ) {
    BAIL_OUT('Unable to retreive test gene from database');
}
my $gene_id = $gene_row->dbxref->accession;

#canonical url with gene name
my $gt = $mt->get_ok("/gene/$name");
$gt->status_is( 200, 'is a successful response for test_CURATED' );
$gt->content_type_like( qr/html/, 'is a html response for test_CURATED' );
$gt->content_like( qr/Gene page for test_CURATED/i,
    'is the title for test_CURATED gene page' );
$gt->content_like( qr/Supported by NIH/i,
    'is the common footer for every gene page' );

#canonical url with gene id
$gt = $mt->get_ok("/gene/$gene_id");
$gt->status_is( 200, "is a successful response for $gene_id" );
$gt->content_type_like( qr/html/, "is a html response for $gene_id" );
$gt->content_like(
    qr/Gene page for test_CURATED/i,
    "is the title for $gene_id gene page"
);
$gt->content_like( qr/Supported by NIH/i,
    'is the common footer for every gene page' );

#canonical url with gene name and format extension
$gt = $mt->get_ok('/gene/test_CURATED.html');
$gt->status_is( 200, 'is a successful response for test_CURATED' );
$gt->content_type_like( qr/html/, 'is a html response for test_CURATED' );
$gt->content_like( qr/Gene page for test_CURATED/i,
    'is the title for test_CURATED gene page' );
$gt->content_like( qr/Supported by NIH/i,
    'is the common footer for every gene page' );

#canonical url with gene name and json format
$gt = $mt->get_ok('/gene/test_CURATED.json');
$gt->status_is( 200, 'is a successful response for test_CURATED' );
$gt->content_type_like( qr/json/, 'is a json response for test_CURATED' );
$gt->content_like( qr/tabview/, 'default layout for json response of gene' );

