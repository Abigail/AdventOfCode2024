#!/opt/perl/bin/perl

use 5.038;

use strict;
use warnings;
no  warnings 'syntax';

use feature 'multidimensional';
use experimental 'for_list';

@ARGV = "input" unless @ARGV;

my $solution_1 = 0;
my $solution_2 = 0;

$/ = "";
while (<>) {
    my ($ax, $ay, $bx, $by, $X, $Y) = /[0-9]+/g;
    my $denom = $ax * $by - $bx * $ay;
    if ($denom == 0) {...}

    for my $part (1, 2) {
        my $X = $X + ($part == 2 ? 10000000000000 : 0);
        my $Y = $Y + ($part == 2 ? 10000000000000 : 0);
        my $num = $X * $by - $Y * $bx;
        next if $num % $denom;
        my $A = $num / $denom;
        my $B = ($X - $A * $ax) / $bx;
        ($part == 2 ? $solution_2 : $solution_1) += 3 * $A + $B;
    }
}


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
