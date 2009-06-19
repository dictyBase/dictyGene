# Copyright (C) 2008-2009, Sebastian Riedel.

package DictyREST::Dispatcher;

use strict;
use warnings;

use base 'MojoX::Dispatcher::Routes';

__PACKAGE__->attr([qw/method user_agent/] => (chained => 1));

# That's not why people watch TV.
# Clever things make people feel stupid and unexpected things make them feel
# scared.
sub match {
    my ($self, $match) = @_;

    # Method
    if (my $regex = $self->method) {
        return undef unless $match->tx->req->method =~ /$regex/;
    }

    # User-Agent header
    if (my $regex = $self->user_agent) {
        my $ua = $match->tx->req->headers->user_agent || '';
        return undef unless $ua =~ /$regex/;
    }

    return $self->SUPER::match($match);
}

1;
__END__

=head1 NAME

DictyREST::Dispatcher - Dispatcher

=head1 SYNOPSIS

    use DictyREST::Dispatcher;

    my $routes = DictyREST::Dispatcher->new;

=head1 DESCRIPTION

L<Mojolicous::Dispatcher> is the default L<DictyREST> dispatcher.

=head1 ATTRIBUTES

L<DictyREST::Dispatcher> inherits all attributes from
L<MojoX::Dispatcher::Routes> and implements the following new ones.

=head2 C<method>

    my $method  = $dispatcher->method;
    $dispatcher = $dispatcher->method(qr/GET|POST/);

=head2 C<user_agent>

    my $ua      = $dispatcher->user_agent;
    $dispatcher = $dispatcher->user_agent(qr/GET|POST/);

=head1 METHODS

L<DictyREST::Dispatcher> inherits all methods from
L<MojoX::Dispatcher::Routes> and implements the following new ones.

=head2 C<match>

    my $match = $routes->match($tx);

=cut
