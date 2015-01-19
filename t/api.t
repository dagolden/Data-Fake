use 5.008001;
use strict;
use warnings;
use Test::More 0.96;

subtest 'Core' => sub {

    package Test1;

    use Data::Fake qw/Core/;

    Test::More::can_ok( "Test1", $_ ) for qw/fake_hash fake_array fake_pick/;
};

done_testing;
# COPYRIGHT

# vim: ts=4 sts=4 sw=4 et tw=75:
