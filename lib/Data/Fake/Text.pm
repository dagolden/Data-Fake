use 5.008001;
use strict;
use warnings;

package Data::Fake::Text;
# ABSTRACT: Fake text data generators

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_words
  fake_sentences
  fake_paragraphs
);

my $LOREM;

=func fake_words

    $generator = fake_words();    # single "lorem" word
    $generator = fake_words($n);  # N "lorem" words, space separated

Returns a generator that provides space-separated L<Text::Lorem> words.
The argument is the number of words to return; the default is one.

=cut

sub fake_words {
    my ($count) = @_;
    require Text::Lorem;
    $LOREM ||= Text::Lorem->new;
    return sub { $LOREM->words($count) };
}

=func fake_sentences

    $generator = fake_sentences();    # single fake sentence
    $generator = fake_sentences($n);  # N sentences

Returns a generator that provides L<Text::Lorem> sentences.
The argument is the number of sentences to return; the default is one.

=cut

sub fake_sentences {
    my ($count) = @_;
    return sub { "" }
      if $count == 0;
    require Text::Lorem;
    $LOREM ||= Text::Lorem->new;
    return sub { $LOREM->sentences($count) };
}

=func fake_paragraphs

    $generator = fake_paragraphs();    # single fake paragraph
    $generator = fake_paragraphs($n);  # N paragraph

Returns a generator that provides L<Text::Lorem> paragraphs.
The argument is the number of paragraphs to return; the default is one.

=cut

sub fake_paragraphs {
    my ($count) = @_;
    require Text::Lorem;
    $LOREM ||= Text::Lorem->new;
    return sub { $LOREM->paragraphs($count) };
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

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
