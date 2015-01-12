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

my $lorem;

sub fake_words {
    my ($count) = @_;
    require Text::Lorem;
    $lorem ||= Text::Lorem->new;
    return sub { $lorem->words($count) };
}

sub fake_sentences {
    my ($count) = @_;
    return sub { "" }
      if $count == 0;
    require Text::Lorem;
    $lorem ||= Text::Lorem->new;
    return sub { $lorem->sentences($count) };
}

sub fake_paragraphs {
    my ($count) = @_;
    require Text::Lorem;
    $lorem ||= Text::Lorem->new;
    return sub { $lorem->paragraphs($count) };
}

1;

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Data::Fake::Core;

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 USAGE

Good luck!

=head1 SEE ALSO

=for :list
* Maybe other modules do related things.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
