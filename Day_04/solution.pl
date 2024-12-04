#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "input";

my $input = [map {[/./g, (".") x 3]} <>];
my $X     = @{$$input [0]} - 3;
my $Y     = @$input;
push @$input => [(".") x @{$$input [0]}] for 1 .. 3;

my $solution_1 = 0;
my $solution_2 = 0;

for (my $x = 0; $x < $X; $x ++) {
    for (my $y = 0; $y < $Y; $y ++) {
        local $" = "";
        if ($$input [$x] [$y] eq 'X') {
            foreach my $dx (-1 .. 1) {
                foreach my $dy (-1 .. 1) {
                    next unless $dx || $dy;
                    my @set = map {$$input [$x + $dx * $_]
                                           [$y + $dy * $_]} 0 .. 3;
                    $solution_1 ++ if "@set" eq "XMAS";
                }
            }
        }
        #
        # If the letter on position $x, $y is an 'A', check the two
        # words crossing: they each need to be either 'MAS' or 'SAM'
        #
        if ($$input [$x] [$y] eq 'A') {
            my @set1 = map {$$input [$x + $_] [$y + $_]} -1 .. 1;
            my @set2 = map {$$input [$x + $_] [$y - $_]} -1 .. 1;
            $solution_2 ++ if ("@set1" eq "MAS" || "@set1" eq "SAM") &&
                              ("@set2" eq "MAS" || "@set2" eq "SAM");
        }
    }
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
