package Math::BigInt::GMP;

use 5.008;
use strict;
use warnings;

use Math::BigInt::Lib 1.999801;

our @ISA = qw< Math::BigInt::Lib >;

our $VERSION = '1.7003';

use XSLoader;
XSLoader::load "Math::BigInt::GMP", $VERSION;

sub import { }                  # catch and throw away
sub api_version() { 2; }

###############################################################################
# Routines not present here are in GMP.xs or inherited from the parent class.

###############################################################################
# routine to test internal state for corruptions

sub _check {
    my ($class, $x) = @_;
    return "Undefined" unless defined $x;
    return "$x is not a reference to Math::BigInt::GMP"
      unless ref($x) eq 'Math::BigInt::GMP';
    return 0;
}

sub STORABLE_freeze {
    my ($self, $cloning) = @_;
    return Math::BigInt::GMP->_str($self);
}

sub STORABLE_thaw {
    my ($self, $cloning, $serialized) = @_;
    Math::BigInt::GMP->_new_attach($self, $serialized);
    return $self;
}

1;

__END__

=pod

=head1 NAME

Math::BigInt::GMP - backend library for Math::BigInt etc. based on GMP

=head1 SYNOPSIS

    # to use it with Math::BigInt
    use Math::BigInt lib => 'GMP';

    # to use it with Math::BigFloat
    use Math::BigFloat lib => 'GMP';

    # to use it with Math::BigRat
    use Math::BigRat lib => 'GMP';

=head1 DESCRIPTION

Math::BigInt::GMP is a backend library for Math::BigInt, Math::BigFloat,
Math::BigRat and related modules.

Math::BigInt::GMP provides support for big integer calculations by means of the
GMP C library. See L<https://gmplib.org/> for more information about the GMP
library.

Math::BigInt::GMP no longer uses Math::GMP, but provides its own XS layer to
access the GMP C library. This cuts out another (Perl subroutine) layer and
also reduces the memory footprint.

Math::BigInt::GMP inherits from Math::BigInt::Lib.

=head1 STATIC FUNCTIONS

=head2 $str = gmp_version();

Returns the underlying GMP library's version as a string, e.g., C<6.2.1>.

=head1 BUGS

Please report any bugs or feature requests to
C<bug-math-bigint-gmp at rt.cpan.org>, or through the web interface at
L<https://rt.cpan.org/Ticket/Create.html?Queue=Math-BigInt-GMP>
(requires login). We will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 SUPPORT

After installing, you can find documentation for this module with the perldoc
command.

    perldoc Math::BigInt::GMP

You can also look for information at:

=over 4

=item GitHub

L<https://github.com/pjacklam/p5-Math-BigInt-GMP>

=item RT: CPAN's request tracker

L<https://rt.cpan.org/Dist/Display.html?Name=Math-BigInt-GMP>

=item MetaCPAN

L<https://metacpan.org/release/Math-BigInt-GMP>

=item CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Math-BigInt-GMP>

=back

=head1 LICENSE

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHORS

Tels E<lt>http://bloodgate.com/E<gt> in 2001-2007.

Thanks to Chip Turner (CHIPT on CPAN) for providing Math::GMP, which was
inspiring my work.

Maintained by Peter John Acklam E<lt>pjacklam@gmail.comE<gt> 2010-2021.

gmp_version() provided by FGasper on GitHub.

=head1 SEE ALSO

L<Math::BigInt::Lib> for a description of the API.

Alternative libraries L<Math::BigInt::Calc>, L<Math::BigInt::FastCalc>, and
L<Math::BigInt::Pari>.

Some of the modules that use these libraries L<Math::BigInt>,
L<Math::BigFloat>, and L<Math::BigRat>.

=cut
