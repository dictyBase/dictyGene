#!perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use FindBin;
use Data::Dumper;
use Test::Mojo;
use lib "$FindBin::Bin/lib";

use_ok('DictyREST');


my $client = Test::Mojo->new(app => 'DictyREST');

#request for gene 
my $tx = $client->get_ok('/gene/DDB_G0288511/gene.json');
$tx->status_is( 200, 'is a successful response for gene');
$tx->content_type_like(qr/json/,  'is a json content for gene');
$tx->content_like(qr/layout.+accordion/,  'has a accordion layout in json content');


#request for GO 
$tx = $client->get_ok('/gene/DDB_G0288511/go');
$tx->status_is(200, 'is a successful response for GO');
$tx->content_type_like(  qr/html/,  'is a html content for GO');
$tx->content_like(qr/Gene page for sadA/i,  'is the title for sadA gene page');
$tx->content_like(qr/Supported by NIH/i,  'is the common footer for every gene page');

#request for GO with json format 
$tx = $client->get_ok('/gene/DDB_G0288511/go.json');
$tx->status_is(200, 'is a successful json response for GO');
$tx->content_type_like(qr/json/,  'is a html content for GO');
$tx->content_like( qr/layout.+accordion/,  'has a row layout in json content');

#request for phenotypes 
$tx = $client->get_ok('/gene/DDB_G0288511/phenotypes');
$tx->status_is(200, 'is a successful response for phenotypes');
$tx->content_type_like(qr/html/,  'is a json content for phenotype');
$tx->content_like(qr/Gene page for sadA/i,  'is the title with phenotype tab selected');
$tx->content_like(qr/Supported by NIH/i,  'is the common footer for every gene page');


#request for phenotypes 
$tx = $client->get_ok('/gene/DDB_G0288511/phenotypes.json');
$tx->status_is(200, 'is a successful response for phenotypes');
$tx->content_type_like( qr/json/,  'is a json content for phenotype');
$tx->content_like(qr/layout.+row/,  'has a row layout in json content for phenotype');


#request for references 
$tx = $client->get_ok('/gene/DDB_G0288511/references');
$tx->status_is( 200, 'is a successful response for references');
$tx->content_type_like( qr/html/,  'is a html content for references');
$tx->content_like(qr/Gene page for sadA/i,  'is the title with reference tab selected');
$tx->content_like(qr/Supported by NIH/i,  'is the common footer for every gene page');


#request for references 
$tx = $client->get_ok('/gene/DDB_G0288511/references.json');
$tx->status_is(200, 'is a successful response for references');
$tx->content_type_like(qr/json/,  'is a json content for references');
$tx->content_like(qr/layout.+column/,  'has a column layout in json content');

#default request for references with gene name 
$tx =$client->get_ok('/gene/sadA/references');
$tx->status_is(200, 'is a successful response for references');
$tx->content_type_like( qr/html/,  'is a html content for references');
$tx->content_like(qr/Gene page for sadA/i,  'is the title with reference tab selected');


#request for references with gene name 
$tx = $client->get_ok('/gene/sadA/references.json');
$tx->status_is(200, 'is a successful response for references');
$tx->content_type_like( qr/json/,  'is a json content for references');
$tx->content_like(qr/layout.+column/,  'has a column layout in json content');


#request for gene 
$tx = $client->get_ok('/gene/DDB_G0286355/gene.json');
$tx->status_is(200, 'is a successful response for mhcA gene');
$tx->content_type_like( qr/json/,  'is a json content for gene');
$tx->content_like(qr/layout.+accordion/,  'has a accordion layout in json content');

=======
my $client = Mojo::Client->new();

my $name = 'test_CURATED';
my ($gene) = dicty::Search::Gene->find(
    -name       => $name,
    -is_deleted => 'false'
);
my $gene_id = $gene->primary_id;
my ($transcript)  = @{ $gene->transcripts };
my $transcript_id = $transcript->primary_id();

#request for gene
my $tx = Mojo::Transaction->new_get("/gene/$gene_id/gene.json");
$client->process_app( 'DictyREST', $tx );
is( $tx->res->code, 200, 'is a successful response for gene' );
like( $tx->res->headers->content_type,
    qr/json/, 'is a json content for gene' );
like( $tx->res->body, qr/layout.+accordion/,
    'has a accordion layout in json content' );

#request for gene with name
$tx = Mojo::Transaction->new_get("/gene/$name/gene.json");
$client->process_app( 'DictyREST', $tx );
is( $tx->res->code, 200, "is a successful response for $name gene" );
like( $tx->res->headers->content_type,
    qr/json/, 'is a json content for gene' );
like( $tx->res->body, qr/layout.+accordion/,
    'has a accordion layout in json content' );

#request for protein
$tx = Mojo::Transaction->new_get("/gene/$gene_id/protein");
$client->process_app( 'DictyREST', $tx );
is( $tx->res->code, 200,
    "is a successful response for protein topic of $name gene" );
like( $tx->res->headers->content_type,
    qr/html/, "is a html content for $name gene" );
like(
    $tx->res->body,
    qr/Gene Page for $name/,
    "is the title for $name gene page"
);

#request for protein with gene name
$tx = Mojo::Transaction->new_get("/gene/$name/protein");
$client->process_app( 'DictyREST', $tx );
is( $tx->res->code, 200,
    "is a successful response for protein topic of $name gene" );
like( $tx->res->headers->content_type,
    qr/html/, "is a html content for $name gene" );
like(
    $tx->res->body,
    qr/Gene Page for $name/,
    "is the title for $name gene page"
);

#request for protein section for json response
$tx = Mojo::Transaction->new_get(
    "/gene/$gene_id/protein/$transcript_id".'.json');
$client->process_app( 'DictyREST', $tx );
is( $tx->res->code, 200,
    'is a successful response for protein section with json query' );
like( $tx->res->headers->content_type,
    qr/json/, 'is a json content for protein' );
like( $tx->res->body, qr/layout.+accordion/, 'has a accordion layout in protein' );
diag($tx->res->body);



