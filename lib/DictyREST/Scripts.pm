# Copyright (C) 2008-2009, Sebastian Riedel.

package DictyREST::Scripts;

use strict;
use warnings;

use base 'Mojo::Scripts';

__PACKAGE__->attr(message => (chained => 1, default => <<'EOF'));
Welcome to the DictyREST Web Framework!

HINT: In case you don't know what you are doing here try the manual!
    perldoc Mojo::Manual
    perldoc Mojo::Manual::GettingStarted

This is the interactive script interface, the syntax is very simple.
    mojolicious <script> <options>

Below you will find a list of available scripts with descriptions.

EOF
__PACKAGE__->attr(
    namespace => (
        chained => 1,
        default => 'DictyREST::Script'
    )
);

# One day a man has everything, the next day he blows up a $400 billion
# space station, and the next day he has nothing. It makes you think.

1;
__END__

=head1 NAME

DictyREST::Scripts - Scripts

=head1 SYNOPSIS

    use Mojo::Scripts;

    my $scripts = DictyREST::Scripts->new;
    $scripts->run(@ARGV);

=head1 DESCRIPTION

L<Mojolicous::Scripts> is a interactive script interface.

=head1 ATTRIBUTES

L<DictyREST::Scripts> inherits all attributes from L<Mojo::Scripts> and
implements the following new ones.

=head2 C<message>

    my $message = $scripts->message;
    $scripts    = $scripts->message('DictyREST!');

=head2 C<namespace>

    my $namespace = $scripts->namespace;
    $scripts      = $scripts->namespace('DictyREST::Scripts');

=head1 METHODS

L<DictyREST::Scripts> inherits all methods from L<Mojo::Scripts>.

=cut
