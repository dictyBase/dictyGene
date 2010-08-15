#!perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use FindBin;
use Data::Dumper;
use Test::Mojo;
use lib "$FindBin::Bin/lib";

#use_ok('DictyREST');

my $mt = Test::Mojo->new( app => 'DictyREST' );
#$mt->get_ok('/gene')->status_is(404)
#    ->content_like( qr/File not found/i, 'is a generic error response' );


#canonical url with gene name
my $gt = $mt->get_ok('/gene/sadA');
$gt->status_is( 200, 'is a successful response for sadA' );
$gt->content_type_like( qr/html/, 'is a html response for sadA' );
$gt->content_like( qr/Gene page for sadA/i,
    'is the title for sadA gene page' );
$gt->content_like( qr/Supported by NIH/i,
    'is the common footer for every gene page' );


#canonical url with gene id
$gt = $mt->get_ok('/gene/DDB_G0288511');
$gt->status_is( 200, 'is a successful response for DDB_G0288511' );
$gt->content_type_like( qr/html/, 'is a html response for DDB_G0288511' );
$gt->content_like( qr/Gene page for sadA/i,
    'is the title for DDB_G0288511 gene page' );
$gt->content_like( qr/Supported by NIH/i,
    'is the common footer for every gene page' );


#canonical url with gene name and format extension
$gt = $mt->get_ok('/gene/sadA.html');
$gt->status_is( 200, 'is a successful response for sadA' );
$gt->content_type_like( qr/html/, 'is a html response for sadA' );
$gt->content_like( qr/Gene page for sadA/i,
    'is the title for sadA gene page' );
$gt->content_like( qr/Supported by NIH/i,
    'is the common footer for every gene page' );

#canonical url with gene name and json format
#$gt = $mt->get_ok('/gene/sadA.json');
#$gt->status_is( 200, 'is a successful response for sadA' );
#$gt->content_type_like( qr/json/, 'is a json response for sadA' );
#$gt->content_like( qr/tabview/, 'default layout for json response of gene' );

exit;
