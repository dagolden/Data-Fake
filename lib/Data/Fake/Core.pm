use 5.008001;
use strict;
use warnings;

package Data::Fake::Core;
# ABSTRACT: General purpose generators

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_hash
  fake_array
  fake_choice
);

sub fake_hash {
    my ($arg) = @_;
}

sub fake_array {
    my ($arg) = @_;
}

sub fake_choice {
    my (@list) = @_;
    my $size = scalar @list;
    return sub { $list[ int( rand($size) ) ] };
}

1;

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Data::Fake::Core;

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 USAGE

Good luck!

=head1 SEE ALSO

=for :list
* Maybe other modules do related things.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
