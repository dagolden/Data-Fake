use 5.008001;
use strict;
use warnings;

package Data::Fake::Core;
# ABSTRACT: General purpose generators

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_hash
  fake_maybe_hash
  fake_array
  fake_var_array
  fake_choice
  fake_random_int
);

use Carp qw/croak/;

=func fake_hash

    $hash_factory = fake_hash(
        {
            name => fake_name,
            pet => fake_choice(qw/dog cat frog/),
        }
    );

    $hash_factory = fake_hash( @hash_or_hash_generators );

The C<fake_hash> function returns a code reference that, when run,
generates a hash reference.

The simplest way to use it is to provide a hash reference with some values
replaced with C<fake_*> generator functions.  When the generator runs, the
hash will be walked recursively and any code reference found will be
replaced with its output.

If more than one argument is provided, when the generator runs, they will
be merged according to the following rules:

=for :list
* code references will be replaced with their outputs
* after replacement, if any arguments aren't hash references, an exception
  will be thrown
* hash references will be shallow-merged left-to-right

This merging is a bit peculiar, but allows for generating hashes that might
have missing or dynamic keys, using L</fake_maybe_hash> and
L</fake_var_hash>.

=cut

sub fake_hash {
    my (@parts) = @_;
    return sub {
        my $result = {};
        for my $next ( map { _transform($_) } @parts ) {
            croak "fake_hash can only merge hash references"
              unless ref($next) eq 'HASH';
            @{$result}{ keys %$next } = @{$next}{ keys %$next };
        }
        return $result;
    };
}

=func fake_maybe_hash

    $hash_factory = fake_maybe_hash(
        0.90, # 90% likely
        {
            name => fake_name()
        }
    );

The C<fake_maybe_hash> function takes a probability and a hash reference or
hash reference generator.  The probability (between 0 and 1.0) indicates
the likelihood that the return value will be a hash generated from the
input.  The rest of the time, an empty hash reference will be returned.

Use this function to help construct hashes that might be missing keys:

    # 25% of the time, generate a hash with a 'spouse' key
    $factory = fake_hash(
        { ... },
        fake_maybe_hash( 0.25, { spouse => fake_name } ),
    );

=cut

sub fake_maybe_hash {
    my ( $prob, $template ) = @_;
    croak "fake_maybe_hash probability must be between 0 and 1.0"
      unless defined($prob) && $prob >= 0 && $prob <= 1.0;
    return sub {
        if ( rand() <= $prob ) {
            my $result = _transform($template);
            croak "fake_maybe_hash input requires a hash reference as input"
              unless ref($result) eq 'HASH';
            return $result;
        }
        return {};
    };
}

sub fake_array {
    my ( $size, $template ) = @_;
    return sub {
        [ map { _transform($template) } 1 .. $size ];
    };
}

sub fake_var_array {
    my ( $min, $max, $template ) = @_;
    return sub {
        my $length = $min + int( rand( $max - $min + 1 ) );
        return [] if $length == 0;
        my $last = $min + $length - 1;
        return [ map { _transform($template) } $min .. $last ];
    };
}

sub fake_choice {
    my (@list) = @_;
    my $size = scalar @list;
    return sub { $list[ int( rand($size) ) ] };
}

=func fake_random_int

    $rand_factory = fake_random_int(1, 6);

Given a minimum and a maximum value as inputs, returns a generator that
will produce a random integer in that range.

=cut

sub fake_random_int {
    my ( $min, $max ) = map { int($_) } @_;
    croak "fake_random_int requires minimum and maximum"
      unless defined $min && defined $max;
    my $range = $max - $min + 1;
    return sub {
        return $min + int( rand($range) );
    };
}

sub _transform {
    my ($template) = @_;

    my $type = ref($template);

    if ( $type eq 'CODE' ) {
        return $template->();
    }
    elsif ( $type eq 'HASH' ) {
        my $copy = {};
        while ( my ( $k, $v ) = each %$template ) {
            $copy->{$k} =
                ref($v) eq 'CODE'  ? $v->()
              : ref($v) eq 'HASH'  ? _transform($v)
              : ref($v) eq 'ARRAY' ? _transform($v)
              :                      $v;
        }
        return $copy;
    }
    elsif ( $type eq 'ARRAY' ) {
        my @copy = map {
                ref $_ eq 'CODE'  ? $_->()
              : ref $_ eq 'HASH'  ? _transform($_)
              : ref $_ eq 'ARRAY' ? _transform($_)
              :                     $_;
        } @$template;
        return \@copy;
    }
    else {
        # literal value
        return $template;
    }
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
