use 5.008001;
use strict;
use warnings;

package Data::Fake;
# ABSTRACT: Declaratively generate fake structured data for testing

our $VERSION = '0.001';

use Import::Into;

sub import {
    my $class = shift;
    for my $m (@_) {
        my $module = "Data::Fake::$m";
        $module->import::into( scalar caller );
    }
}

1;

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Data::Fake qw/Core Names Text Dates/;

    my $hero_factory = fake_hash(
        {
            name      => fake_name(),
            battlecry => fake_sentence(),
            birthday  => fake_date("%Y-%m-%d"),
            friends   => fake_array( 3, 6, fake_name() ),
            gender    => fake_choice(qw/Male Female Other/),
        }
    );

    my $hero = $hero_factory->();

=head1 DESCRIPTION

This module generates structured data.

=head1 USAGE

Good luck!

=head1 SEE ALSO

=for :list
* L<Data::Faker> – similar but object oriented; always loads all plugins
* L<Data::Random> – generate several random types of data
* L<Test::Sims> – generator for libraries generating random data
* L<Text::Lorem> – just fake text

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
