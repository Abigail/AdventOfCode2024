#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "input";

undef $/;
my @stones = <> =~ /[0-9]+/g;

sub engrave ($stone, $times) {
    state $cache;
    my $len = length ($stone);
    $$cache {$stone} {$times} //= 
        $times   == 0 ? 1
      : $stone   == 0 ? engrave (1,                                $times - 1)
      : $len % 2 == 0 ? engrave (0 + substr ($stone, 0, $len / 2), $times - 1) +
                        engrave (0 + substr ($stone,    $len / 2), $times - 1)
      :                 engrave ($stone * 2024,                    $times - 1)
}

my $solution_1 = 0;
my $solution_2 = 0;

$solution_1 += engrave ($_, 25) for @stones;
$solution_2 += engrave ($_, 75) for @stones;


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
