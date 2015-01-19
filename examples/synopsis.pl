use v5.10;
use strict;
use warnings;

use Data::Fake qw/Core Names Text Dates/;
use Data::Dumper;

my $hero_factory = fake_hash(
    {
        name      => fake_name(),
        battlecry => fake_sentences(1),
        birthday  => fake_past_datetime("%Y-%m-%d"),
        friends   => fake_var_array( 3, 6, fake_name() ),
        gender    => fake_pick(qw/Male Female Other/),
    }
);

my $hero = $hero_factory->();

say Dumper($hero);
