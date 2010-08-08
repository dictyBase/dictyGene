#!/usr/bin/env perl

use strict;
use local::lib '/home/ubuntu/dictyBase/Libs/modern-perl-dapper';
use FindBin;
use Mojo::Server::PSGI;
use Plack::Builder;
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../lib";
use lib 'lib';
use lib '/home/ubuntu/dicty/lib';

BEGIN { $ENV{ORACLE_HOME} = '/usr/local/instantclient_10_2';
	$ENV{DATABASE} = 'DICTYBASE';
	$ENV{CHADO_USER} = 'CGM_CHADO';
	$ENV{CHADO_PW} = 'th0mp50n';
	$ENV{USER} = 'ubuntu';
	$ENV{PASSWORD} = 'rctdwak';
	$ENV{DBUSER} = 'CGM_DDB';
	$ENV{LD_LIBRARY_PATH} = '/usr/local/instantclient_10_2';
	$ENV{TNS_ADMIN} = '/usr/local/instantclient_10_2';
	$ENV{MOJO_MODE} = $ENV{PLACK_ENV};
};

my $psgi = Mojo::Server::PSGI->new(app_class => 'DictyREST');
my $app = sub {$psgi->run(@_)};
$app;

