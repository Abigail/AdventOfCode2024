#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "input";
# @ARGV = "example-2";

undef $/;

$_ = <>;
my ($factor, $solution_1, $solution_2);

/ (?{ $factor = 1; $solution_1 = 0; $solution_2 = 0; })
  (?:
      \Qdo()\E                 (?{ $factor = 1 })
   |  \Qdon't()\E              (?{ $factor = 0 })
   |  mul\(([0-9]+),([0-9]+)\) (?{ $solution_1 += $1 * $2;
                                   $solution_2 += $1 * $2 * $factor })
   | [^dm]+
   | [dm] )*  /x;

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
