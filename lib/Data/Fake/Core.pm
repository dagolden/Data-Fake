use 5.008001;
use strict;
use warnings;

package Data::Fake::Core;
# ABSTRACT: General purpose generators

our $VERSION = '0.003';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_hash
  fake_array
  fake_pick
  fake_binomial
  fake_weighted
  fake_int
  fake_float
  fake_digits
  fake_template
  fake_join
);

our @EXPORT_OK = qw/_transform/;

use Carp qw/croak/;
use List::Util qw/sum/;

=func fake_hash

    $generator = fake_hash(
        {
            name => fake_name,
            pet => fake_pick(qw/dog cat frog/),
        }
    );

    $generator = fake_hash( @hash_or_hash_generators );

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
* hash references will be shallow-merged

This merging allows for generating sections of hashes differently or
generating hashes that have missing keys (e.g. using L</fake_binomial>):

    # 25% of the time, generate a hash with a 'spouse' key
    $factory = fake_hash(
        { ... },
        fake_binomial( 0.25, { spouse => fake_name() }, {} ),
    );

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

=func fake_array

    $generator = fake_array( 5, fake_digits("###-###-####") );

The C<fake_array> takes a positive integer size and source argument and
returns a generator that returns an array reference with each element built
from the source.

If the size is a code reference, it will be run and can set a different size
for every array generated:

    # arrays from size 1 to size 6
    $generator = fake_array( fake_int(1,6), fake_digits("###-###-###") );

If the source is a code reference, it will be run; if the source is a hash
or array reference, it will be recursively evaluated like C<fake_hash>.

=cut

sub fake_array {
    my ( $size, $template ) = @_;
    return sub {
        [ map { _transform($template) } 1 .. _transform($size) ];
    };
}

=func fake_pick

    $generator = fake_pick( qw/one two three/ );
    $generator = fake_pick( @generators );

Given literal values or code references, returns a generator that randomly
selects one of them with equal probability.  If the choice is a code
reference, it will be run; if the choice is a hash or array reference, it
will be recursively evaluated like C<fake_hash> or C<fake_array> would do.

=cut

sub fake_pick {
    my (@list) = @_;
    my $size = scalar @list;
    return sub { _transform( $list[ int( rand($size) ) ] ) };
}

=func fake_binomial

    $generator = fake_binomial(
        0.90,
        { name => fake_name() }, # 90% likely
        {},                      # 10% likely
    );

    $generator = fake_binomial( $prob, $lte_outcome, $gt_outcome );

The C<fake_binomial> function takes a probability and two outcomes.  The
probability (between 0 and 1.0) indicates the likelihood that the return
value will the first outcome.  The rest of the time, the return value will
be the second outcome.  If the outcome is a code reference, it will be run;
if the outcome is a hash or array reference, it will be recursively
evaluated like C<fake_hash> or C<fake_array> would do.

=cut

sub fake_binomial {
    my ( $prob, $first, $second ) = @_;
    croak "fake_binomial probability must be between 0 and 1.0"
      unless defined($prob) && $prob >= 0 && $prob <= 1.0;
    return sub {
        return _transform( rand() <= $prob ? $first : $second );
    };
}

=func fake_weighted

    $generator = fake_weighted(
        [ 'a_choice',          1 ],
        [ 'ten_times_likely', 10 ],
        [ $another_generator,  1 ],
    );

Given a list of array references, each containing a value and a
non-negative weight, returns a generator that randomly selects a value
according to the relative weights.

If the value is a code reference, it will be run; if it is a hash or array
reference, it will be recursively evaluated like C<fake_hash> or C<fake_array>
would do.

=cut

sub fake_weighted {
    my (@list) = @_;
    return sub { }
      unless @list;

    if ( @list != grep { ref($_) eq 'ARRAY' } @list ) {
        croak("fake_weighted requires a list of array references");
    }

    # normalize weights into cumulative probabilities
    my $sum = sum( 0, map { $_->[1] } @list );
    my $max = 0;
    for my $s (@list) {
        $s->[1] = $max += $s->[1] / $sum;
    }
    my $last = pop @list;

    return sub {
        my $rand = rand();
        for my $s (@list) {
            return _transform( $s->[0] ) if $rand <= $s->[1];
        }
        return _transform( $last->[0] );
    };
}

=func fake_int

    $generator = fake_int(1, 6);

Given a minimum and a maximum value as inputs, returns a generator that
will produce a random integer in that range.

=cut

sub fake_int {
    my ( $min, $max ) = map { int($_) } @_;
    croak "fake_int requires minimum and maximum"
      unless defined $min && defined $max;
    my $range = $max - $min + 1;
    return sub {
        return $min + int( rand($range) );
    };
}

=func fake_float

    $generator = fake_float(1.0, 6.0);

Given a minimum and a maximum value as inputs, returns a generator that
will produce a random floating point value in that range.

=cut

sub fake_float {
    my ( $min, $max ) = @_;
    croak "fake_float requires minimum and maximum"
      unless defined $min && defined $max;
    my $range = $max - $min;
    return sub {
        return $min + rand($range);
    };
}

=func fake_digits

    $generator = fake_digits('###-####'); # "555-1234"
    $generator = fake_digits('\###');     # "#12"

Given a text pattern, returns a generator that replaces all occurrences of
the sharp character (C<#>) with a randomly selected digit.  To have a
literal sharp character, escape it with a backslash.

Use this for phone numbers, currencies, or whatever else needs random
digits:

    fake_digits("###-##-####");     # US Social Security Number
    fake_digits("(###) ###-####");  # (800) 555-1212

=cut

my $DIGIT_RE = qr/(?<!\\)#/;

sub fake_digits {
    my ($template) = @_;
    return sub {
        my $copy = $template;
        1 while $copy =~ s{$DIGIT_RE}{int(rand(10))}e;
        $copy =~ s{\\#}{#}g;
        return $copy;
    };
}

=func fake_template

    $generator = fake_template("Hello, %s", fake_name());

Given a sprintf-style text pattern and a list of generators, returns a
generator that, when run, executes the generators and returns the string
populated with the output.

Use this for creating custom generators from other generators.

=cut

sub fake_template {
    my ( $template, @args ) = @_;
    return sub {
        return sprintf( $template, map { _transform($_) } @args );
    };
}

=func fake_join

    $generator = fake_join(" ", fake_first_name(), fake_surname() );

Given a character to join on a list of literals or generators, returns a
generator that, when run, executes any generators and returns them concatenated
together, separated by the separator character.

The separator itself may also be a generator if you want that degree of
randomness as well.

    $generator = fake_join( fake_pick( q{}, q{ }, q{,} ), @args );

=cut

sub fake_join {
    my ( $char, @args ) = @_;
    return sub {
        return join( _transform($char), map { _transform($_) } @args );
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

    $generator = fake_hash(
        {
            ssn             => fake_digits("###-##-###"),
            phrase          => fake_template(
                                "%s world", fake_pick(qw/hello goodbye/)
                               ),
            die_rolls       => fake_array( 3, fake_int(1, 6) ),
            temperature     => fake_float(-20.0, 120.0),
        }
    );

=head1 DESCRIPTION

This module provides a general-purpose set of fake data functions to generate
structured data, numeric data, structured strings, and weighted alternatives.

All functions are exported by default.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
