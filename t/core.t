use 5.008001;
use strict;
use warnings;
use Test::More 0.96;
use Test::Deep;

use Data::Fake::Core;

subtest 'fake_choice' => sub {
    my %list = map { $_ => 1 } qw/one two three/;
    my $chooser = fake_choice( keys %list );
    for ( 1 .. 10 ) {
        my $got = $chooser->();
        ok( exists( $list{$got} ), "got key $got in list" );
    }
};

subtest 'fake_array' => sub {
    my $re = re(qr/^(?:Larry|Damian|Randall)/);

    for my $size ( 2 .. 4 ) {
        my $factory = fake_array( $size, fake_choice(qw/Larry Damian Randall/) );

        my $expected = [ map { $re } 1 .. $size ];

        for my $i ( 1 .. 3 ) {
            my $got = $factory->();
            cmp_deeply( $got, $expected, "generated array $i of size $size" );
        }
    }

    my $got = fake_array( 0, "Larry" )->();
    cmp_deeply( $got, [], "generated array of size 0 is empty" );

    $got = fake_array( 2, { first => 1 } )->();
    cmp_deeply(
        $got,
        [ { first => 1 }, { first => 1 } ],
        "generated array with constant hash structure"
    );

    $got = fake_array( 2, { name => fake_choice(qw/Larry Damian Randall/) } )->();
    cmp_deeply(
        $got,
        [ { name => $re }, { name => $re } ],
        "generated array with dynamic hash structure"
    );
};

subtest 'fake_var_array' => sub {
    my $re = qr/^(?:Larry|Damian|Randall)/;

    for my $max_size ( 3 .. 4 ) {
        for my $min_size ( 0 .. 2 ) {
            my $factory =
              fake_var_array( $min_size, $max_size, fake_choice(qw/Larry Damian Randall/) );

            for my $i ( 1 .. 10 ) {
                my $got    = $factory->();
                my $length = @$got;
                ok(
                    $length >= $min_size && $length <= $max_size,
                    "var array size $length between $min_size and $max_size"
                );
                for my $item (@$got) {
                    like( $item, $re, "element value correct" );
                }
            }
        }
    }
};

subtest 'fake_hash' => sub {
    my $factory = fake_hash(
        {
            name  => fake_choice(qw/Larry Damian Randall/),
            phone => fake_hash(
                {
                    home => fake_choice( "555-1212", "555-1234" ),
                    work => fake_choice( "666-1234", "666-7777" ),
                }
            ),
            color => 'blue',
        }
    );

    my $expected = {
        name  => re(qr/^(?:Larry|Damian|Randall)/),
        phone => {
            home => re(qr/^555/),
            work => re(qr/^666/),
        },
        color => 'blue',
    };

    for my $i ( 1 .. 5 ) {
        my $got = $factory->();
        cmp_deeply( $got, $expected, "generated hash $i" );
    }

    $factory = fake_hash(
        { name => fake_choice(qw/Larry Damian Randall/) },
        fake_hash(
            {
                phone => {
                    home => fake_choice( "555-1212", "555-1234" ),
                    work => fake_choice( "666-1234", "666-7777" ),
                },
            }
        ),
        { color => 'blue' },
    );

    cmp_deeply( $factory->(), $expected, "generated hash from fragments" );
};

done_testing;
# COPYRIGHT

# vim: ts=4 sts=4 sw=4 et tw=75:
