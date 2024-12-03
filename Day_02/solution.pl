#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift || "input";

my $solution_1 = 0;
my $solution_2 = 0;

sub safe (@levels) {
    my $sign   = $levels [0] - $levels [1];

    for (my $i = 0; $i < @levels - 1; $i ++) {
        my $diff = $levels [$i] - $levels [$i + 1];
        return 0 if abs ($diff) > 3 || $sign * $diff <= 0;
    }

    return 1;
}

REPORT: while (<>) {
    my @levels   = split;
    if (safe @levels) {
        $solution_1 ++;
        $solution_2 ++;
        next REPORT;
    }
    #
    # We could be smart and just remove levels where there are glitches,
    # but that'll be tricky to do all cases correctly. Instead, we just
    # try removing all levels one-by-one, until we have success. 
    #
    for (my $i = 0; $i < @levels; $i ++) {
        my @reduced = @levels [grep {$i != $_} keys @levels];
        if (safe @reduced) {
            $solution_2 ++;
            next REPORT;
        }
    }
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
