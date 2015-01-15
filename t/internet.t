use 5.008001;
use strict;
use warnings;
use Test::More 0.96;

use Data::Fake::Internet;

subtest 'fake_tld' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = fake_tld->();
        ok( defined($got), "TLD ($got) is defined" );
    }
};

subtest 'fake_domain' => sub {
    for my $i ( 0 .. 5 ) {
        my $got = fake_domain->();
        ok( defined($got), "domain ($got) is defined" );
        like( $got, qr/\w\.\w/, "domain has dot separator" );
    }
};

done_testing;
# COPYRIGHT

# vim: ts=4 sts=4 sw=4 et tw=75:
