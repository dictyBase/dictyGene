use Mojo::Server::PSGI;

my $psgi = Mojo::Server::PSGI->new(app_class => 'DictyREST');
my $app = sub {$psgi->run(@_)};
$app;

