#!/usr/bin/env perl

use strict;
use local::lib '/home/ubuntu/dictyBase/Libs/modern-perl-dapper';
use FindBin;
use Mojo::Server::PSGI;
use Plack::Builder;
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../lib";
use lib ('lib','/home/ubuntu/dicty/lib');

BEGIN { $ENV{ORACLE_HOME} = '/oracle/10g';
	$ENV{DATABASE} = 'DICTYBASE';
	$ENV{CHADO_USER} = 'CGM_CHADO';
	$ENV{CHADO_PW} = 'CGM_CHADO';
	$ENV{USER} = 'CGM_DDB';
	$ENV{PASSWORD} = 'CGM_DDB';
	$ENV{DBUSER} = 'CGM_DDB';
	$ENV{MOJO_MODE} = $ENV{PLACK_ENV};
};

my $psgi = Mojo::Server::PSGI->new(app_class => 'DictyREST');
my $app = sub {$psgi->run(@_)};

builder {
	enable 'Debug';
	enable 'Debug::Parameters';
	enable 'Debug::ModuleVersions';
	enable 'Debug::PerlConfig';
	$app;
}

