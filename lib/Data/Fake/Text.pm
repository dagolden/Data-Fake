use 5.008001;
use strict;
use warnings;

package Data::Fake::Text;
# ABSTRACT: Fake text data generators

our $VERSION = '0.006';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_words
  fake_sentences
  fake_paragraphs
);

use Data::Fake::Core qw/_transform/;

my $LOREM;

=func fake_words

    $generator = fake_words();    # single "lorem" word
    $generator = fake_words($n);  # N "lorem" words, space separated
    $generator = fake_words( fake_int(1, 3) ); # random number of them

Returns a generator that provides space-separated L<Text::Lorem> words as a
single scalar value.  The argument is the number of words to return (or a
code reference to provide the number of words); the default is one.

=cut

sub fake_words {
    my ($count) = @_;
    $count = 1 unless defined $count;
    require Text::Lorem;
    $LOREM ||= Text::Lorem->new;
    return sub { scalar $LOREM->words( _transform($count) ) };
}

=func fake_sentences

    $generator = fake_sentences();    # single fake sentence
    $generator = fake_sentences($n);  # N sentences
    $generator = fake_sentences( fake_int(1, 3) ); # random number of them

Returns a generator that provides L<Text::Lorem> sentences as a single
scalar value.  The argument is the number of sentences to return (or a code
reference to provide the number of sentences); the default is one.

=cut

sub fake_sentences {
    my ($count) = @_;
    $count = 1 unless defined $count;
    return sub { "" }
      if $count == 0;
    require Text::Lorem;
    $LOREM ||= Text::Lorem->new;
    return sub { scalar $LOREM->sentences( _transform($count) ) };
}

=func fake_paragraphs

    $generator = fake_paragraphs();    # single fake paragraph
    $generator = fake_paragraphs($n);  # N paragraph
    $generator = fake_paragraphs( fake_int(1, 3) ); # random number of them

Returns a generator that provides L<Text::Lorem> paragraphs as a single
scalar value.  The argument is the number of paragraphs to return (or a
code reference to provide the number of paragraphs); the default is one.

=cut

sub fake_paragraphs {
    my ($count) = @_;
    $count = 1 unless defined $count;
    require Text::Lorem;
    $LOREM ||= Text::Lorem->new;
    return sub { scalar $LOREM->paragraphs( _transform($count) ) };
}

1;

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Data::Fake::Text;

    fake_words(2)->();
    fake_sentences(3)->();
    fake_paragraphs(1)->();

=head1 DESCRIPTION

This module provides fake data generators for random words and other
textual data.

All functions are exported by default.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
