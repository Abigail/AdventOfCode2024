#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "input";

my $solution_1 = 0;
my $solution_2 = 0;

my $map = [map {[/[0-9]/g, "."]} <>];
push @$map => [(".") x @{$$map [0]}];

#
# Find the trail heads
#
my @trailheads;
for (my $x = 0; $x < @{$$map [0]}; $x ++) {
    for (my $y = 0; $y < @$map; $y ++) {
        push @trailheads => [$x, $y] if $$map [$x] [$y] eq '0';
    }
}

#
# Perform a BFS from each trailhead, keeping track of how often
# a point can be reached. After reaching all the endpoints, tally
# them, and the number of ways endpoints can be reached
#
foreach my $trailhead (@trailheads) {
    my @todo = $trailhead;
    my %seen;
       $seen {$$trailhead [0], $$trailhead [1]} = 1;
    while (@todo) {
        my ($x, $y) = @{shift @todo};
        foreach my ($n_x, $n_y) ($x - 1, $y, $x, $y - 1,
                                 $x + 1, $y, $x, $y + 1) {
            if ($$map [$n_x] [$n_y] ne '.' &&
                $$map [$n_x] [$n_y] == $$map [$x] [$y] + 1) {
                push @todo => [$n_x, $n_y] unless $seen {$n_x, $n_y};
                $seen {$n_x, $n_y} += $seen {$x, $y};
            }
        }
    }
    foreach my $point (keys %seen) {
        my ($x, $y) = split $; => $point;
        if ($$map [$x] [$y] eq '9') {
            $solution_1 ++;
            $solution_2 += $seen {$point};
        }
    }
}


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
