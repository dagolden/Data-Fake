use 5.008001;
use strict;
use warnings;

package Data::Fake::Dates;
# ABSTRACT: Fake date data generators

our $VERSION = '0.006';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_past_epoch
  fake_future_epoch
  fake_past_datetime
  fake_future_datetime
);

use Time::Piece 1.27; # portability fixes

sub _past { int( rand(time) ) }

sub _future {
    my $now = time;
    return $now + int( rand($now) );
}

=func fake_past_epoch

    $generator = fake_past_epoch();

This returns a generator that gives a randomly-selected integer number of
seconds between the Unix epoch and the current time.

=cut

sub fake_past_epoch { \&_past }

=func fake_future_epoch

    $generator = fake_future_epoch();

This returns a generator that gives a randomly-selected integer number of
seconds between the the current time and a period as far into the future as
the Unix epoch is in the past (i.e. about 45 years as of 2015).

=cut

sub fake_future_epoch { \&_future }

=func fake_past_datetime

    $generator = fake_past_datetime();
    $generator = fake_past_datetime("%Y-%m-%d");
    $generator = fake_past_datetime($strftime_format);

This returns a generator that selects a past datetime like
C<fake_past_epoch> does but formats it as a string using FreeBSD-style
C<strftime> formats.  (See L<Time::Piece> for details.)

The default format is ISO8601 UTC "Zulu" time (C<%Y-%m-%dT%TZ>).

=cut

sub fake_past_datetime {
    my ($format) = @_;
    $format ||= "%Y-%m-%dT%H:%M:%SZ";
    return sub {
        Time::Piece->strptime( _past(), "%s" )->strftime($format);
    };
}

=func fake_future_datetime

    $generator = fake_future_datetime();
    $generator = fake_future_datetime("%Y-%m-%d");
    $generator = fake_future_datetime($strftime_format);

This returns a generator that selects a future datetime like
C<fake_future_epoch> does but formats it as a string using FreeBSD-style
C<strftime> formats.  (See L<Time::Piece> for details.)

The default format is ISO8601 UTC "Zulu" time (C<%Y-%m-%dT%TZ>).

=cut

sub fake_future_datetime {
    my ($format) = @_;
    $format ||= "%Y-%m-%dT%H:%M:%SZ";
    return sub {
        Time::Piece->strptime( _future(), "%s" )->strftime($format);
    };
}

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Data::Fake::Dates;

    $past   = fake_past_epoch()->();
    $future = fake_future_epoch()->();

    $past   = fake_past_datetime()->();     # ISO-8601 UTC
    $future = fake_future_datetime()->();   # ISO-8601 UTC

    $past   = fake_past_datetime("%Y-%m-%d")->();
    $future = fake_future_datetime("%Y-%m-%d")->();

=head1 DESCRIPTION

This module provides fake data generators for past and future dates and times.

All functions are exported by default.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
