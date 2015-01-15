use 5.008001;
use strict;
use warnings;

package Data::Fake::Internet;
# ABSTRACT: Fake Internet data generators

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_tld
  fake_domain
);

use Data::Fake::Text ();

my ( @domain_suffixes, $domain_suffix_count );

sub _domain_suffix { return $domain_suffixes[ int( rand($domain_suffix_count) ) ] }

sub fake_tld {
    return sub { _domain_suffix };
}

sub fake_domain {
    my $prefix_gen = Data::Fake::Text::fake_words(2);
    return sub {
        my $prefix = $prefix_gen->();
        $prefix =~ s/\s//g;
        join( ".", $prefix, _domain_suffix );
    };
}

# list and frequencey of most common domains suffixes taken from moz.org
# list of top 500 domains by inbound root domain links

my @domain_suffix_freqs = qw(
  com     295
  org     29
  edu     27
  gov     25
  net     15
  co.uk   12
  ru      9
  jp      7
  ne.jp   7
  de      6
  co.jp   5
  fr      4
  gov.au  3
  io      3
  com.cn  3
  it      3
  cn      3
  cz      3
  gov.cn  2
  me      2
  ca      2
  com.br  2
  co      2
  us      2
  com.au  2
  pl      2
  uk      2
  ac.uk   2
  info    1
  gl      1
  tx.us   1
  la      1
  com.hk  1
  gd      1
  vu      1
  eu      1
  es      1
  int     1
  tv      1
  or.jp   1
  mil     1
  cc      1
  ch      1
  ly      1
  org.au  1
  net.au  1
  fm      1
  be      1
  nl      1
);

for my $i ( 0 .. @domain_suffix_freqs / 2 - 1 ) {
    my ( $s, $n ) =
      ( $domain_suffix_freqs[ 2 * $i ], $domain_suffix_freqs[ 2 * $i + 1 ] );
    push @domain_suffixes, ($s) x $n;
}

$domain_suffix_count = @domain_suffixes;

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
