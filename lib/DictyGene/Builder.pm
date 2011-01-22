package DictyGene::Builder;
use File::Spec::Functions;
use Carp;
use File::Path;
use Path::Class;
use Try::Tiny;
use TAP::Harness;
use base qw/Module::Build/;

sub load_core_fixture {
    my ($self) = @_;

    require dicty::Tests::Data;
    my $data = dicty::Tests::Data->new();
    $self->notes( loader => $data );

    if ( !$data->check_chromosome() ) {
        try {
            $data->insert_core_data();
        }
        catch {
            die "unable to insert data: $_";
        }
    }
}

sub load_fixture {
    my ($self) = @_;

    require dicty::Tests::Data;
    my $data = dicty::Tests::Data->new();
    $self->notes( loader => $data );

    if ( !$data->check_chromosome() ) {
        try {
            $data->insert_whole_chromosome();
        }
        catch {
            die "unable to insert data: $_";
        }
    }
}

sub unload_fixture {
    my ($self) = @_;
    my $loader = $self->notes('loader');
    try {
        $loader->unload_data();
    }
    catch {
        die "error in unloading: $_";
    }
}

sub ACTION_test {
    my ( $self, @arg ) = @_;
    $self->load_fixture();
    $self->SUPER::ACTION_test(@arg);
    $self->unload_fixture;
}

1;
