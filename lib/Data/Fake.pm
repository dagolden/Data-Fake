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

    my $hero_generator = fake_hash(
        {
            name      => fake_name(),
            battlecry => fake_sentences(1),
            birthday  => fake_past_date("%Y-%m-%d"),
            friends   => fake_var_array( 3, 6, fake_name() ),
            gender    => fake_choice(qw/Male Female Other/),
        }
    );

    my $hero = $hero_generator->();

    ### example output ###
    # {
    #    'name'      => 'Antonio Nicholas Preston'
    #    'battlecry' => 'Est ipsum corrupti quia voluptatibus.',
    #    'birthday'  => '2004-04-21',
    #    'friends'   => [
    #                     'Jaylin Lillianna Morgan',
    #                     'Colin Noel Estes',
    #                     'Justice Aron Hale',
    #                     'Franco Zane Oneil'
    #                   ],
    #    'gender'    => 'Male',
    # };

=head1 DESCRIPTION

This module generates randomized, fake structured data using declarative
syntax.

C<Data::Fake> is built on higher-order programming principles.  It provides
users with "factory" functions, which create "generator" functions for
specific pieces of data.

Wherever randomized, fake data is desired, a generator code reference is
used as a placeholder for the desired output.  Each time the top-level
generator is run, nested generators are recursively run to turn
placeholders into the desired randomized data.

For example, the SYNOPSIS declares the desired form of a "hero" using the
C<fake_hash> factory function.  The input is a hash-reference, with nested
generators created as placeholders by the C<fake_name>, C<fake_sentences>,
etc. factory functions:

    my $hero_generator = fake_hash(
        {
            name      => fake_name(),
            battlecry => fake_sentences(1),
            birthday  => fake_past_date("%Y-%m-%d"),
            friends   => fake_var_array( 3, 6, fake_name() ),
            gender    => fake_choice(qw/Male Female Other/),
        }
    );

Every time C<$hero_generator> is run, a new hash is generated based
on the template and nested generators.

=head1 USAGE

=head2 Loading the right submodules

Factory functions are exported by submodules, loosely grouped by topic by
submodules:

=for :list
* L<Data::Fake::Core> – general purpose generators: hashes, arrays,
  numeric values, string templates
* L<Data::Fake::Company> – company name, job title
* L<Data::Fake::Dates> – past and future dates
* L<Data::Fake::Internet> – domain names, email addresses
* L<Data::Fake::Names> – first and last names
* L<Data::Fake::Text> – characters, words, sentences, paragraphs

Submodules can be loaded directly, to control exactly which functions are
exported, or they can be loaded by the C<Data::Fake> import function like
so:

    use Data::Fake qw/Core Company Dates Names/;

In this case, the listed submodules are loaded and all their functions are
imported.

=head2 Constructing the desired output

Use the factory functions to construct a generator for your data.  Start
with the highest level structure using
L<fake_hash|Data::Fake::Core/fake_hash> or
L<fake_array|Data::Fake::Core/fake_array>.  Use other factory functions to
create placeholders with specific data types.

For example, a hash generator with placeholders for phone numbers:

    $hash_generator = fake_hash(
        {
            home => fake_digits("###-###-####"),
            work => fake_digits("###-###-####"),
            cell => fake_digits("###-###-####"),
        }
    );

Or build them up piece by piece.  For example, an array of 100 of the
previous hash references:

    $array_generator = fake_array( 100, $hash_generator );

Then generate the hundred instances, each with three fake phone numbers:

    $aoh = $array_generator->();

See L<Data::Fake::Examples> for ideas for how to use and combine
generators.

=head1 CONTRIBUTING

If you have ideas for additional generator functions and think they would
be sensible additions to the main distribution, please open a support ticket
to discuss it.  To be included in the main distribution, additional
dependencies should be have few, if any, additional dependencies.

If you would like to release your own distributions in the C<Data::Fake::*>
namespace, please follow the conventions of the existing modules.

=head1 SEE ALSO

=for :list
* L<Data::Faker> – similar but object oriented; always loads all plugins
* L<Data::Random> – generate several random types of data
* L<Test::Sims> – generator for libraries generating random data
* L<Text::Lorem> – just fake text

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
