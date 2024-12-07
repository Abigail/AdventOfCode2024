#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "example-1";
@ARGV = "input";

my $solution_1 = 0;
my $solution_2 = 0;

sub can_reach ($total, $part, $sub, @values) {
    return 0 if $sub >  $total;
    return      $sub == $total if !@values;
    my $value = shift @values;
    return               can_reach ($total, $part, $sub + $value, @values) ||
                         can_reach ($total, $part, $sub * $value, @values) ||
           $part == 2 && can_reach ($total, $part, $sub . $value, @values)
}


while (<>) {
    my ($total, @values) = /[0-9]+/g;
    $solution_1 += $total if can_reach $total, 1, 0, @values;
    $solution_2 += $total if can_reach $total, 2, 0, @values;
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
