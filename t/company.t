use 5.008001;
use strict;
use warnings;
use Test::More 0.96;

use Data::Fake::Company;

subtest 'fake_title' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = fake_title->();
        ok( defined($got), "title ($got) is defined" );
    }
};

done_testing;
# COPYRIGHT

# vim: ts=4 sts=4 sw=4 et tw=75:
