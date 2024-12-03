#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "input";

undef $/;

my $input = <>;
my $solution_1 = 0;
my $solution_2 = 0;
my $factor     = 1;

while ($input =~ /mul\((?<f>[0-9]+),(?<s>[0-9]+)\) |
                  (?<on>  \Qdo()\E)                |
                  (?<off> \Qdon't()\E)/xg) {
    if ($+ {on})  {$factor = 1; next}
    if ($+ {off}) {$factor = 0; next}
    $solution_1 += $+ {f} * $+ {s};
    $solution_2 += $+ {f} * $+ {s} * $factor;
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
