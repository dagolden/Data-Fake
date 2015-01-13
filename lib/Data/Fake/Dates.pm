use 5.008001;
use strict;
use warnings;

package Data::Fake::Dates;
# ABSTRACT: Fake date data generators

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_past_epoch
  fake_future_epoch
  fake_past_datetime
  fake_future_datetime
);

use Time::Piece;

sub _past { int( rand(time) ) }

sub _future {
    my $now = time;
    return $now + int( rand($now) );
}

sub fake_past_epoch { \&_past }

sub fake_future_epoch { \&_future }

sub fake_past_datetime {
    my ($format) = @_;
    $format ||= "%Y-%m-%dT%TZ";
    return sub {
        Time::Piece->strptime( _past(), "%s" )->strftime($format);
    };
}

sub fake_future_datetime {
    my ($format) = @_;
    $format ||= "%Y-%m-%dT%TZ";
    return sub {
        Time::Piece->strptime( _future(), "%s" )->strftime($format);
    };
}

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
