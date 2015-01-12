use 5.008001;
use strict;
use warnings;
use Test::More 0.96;

use Data::Fake::Core;

subtest 'fake_choice' => sub {
    my %list = map { $_ => 1 } qw/one two three/;
    my $chooser = fake_choice( keys %list );
    for ( 1 .. 20 ) {
        my $got = $chooser->();
        ok( exists( $list{$got} ), "got key $got in list" );
    }
};

done_testing;
# COPYRIGHT

# vim: ts=4 sts=4 sw=4 et tw=75:
