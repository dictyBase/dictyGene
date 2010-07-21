#!/usr/bin/env perl

use strict;
use local::lib '/home/ubuntu/dictyBase/Libs/modern-perl-dapper';
use FindBin;
use Mojo::Server::FastCGI;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
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
};

my $fcgi = Mojo::Server::FastCGI->new(app_class => 'DictyREST');
$fcgi->run;

