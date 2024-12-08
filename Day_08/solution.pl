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
my %seen_1;
my %seen_2;

my $map = [map {[/./g]} <>];
my $X = @$map;
my $Y = @{$$map [0]};

sub same ($p1, $p2) {
    return if $$p1 [0] == $$p2 [0] && $$p1 [1] == $$p2 [1]
}

sub colinear ($p1, $p2, $p3) {
    return 0 if same ($p1, $p2) || same ($p1, $p3) || same ($p2, $p3);
    my $diff_x1 = $$p1 [0] - $$p2 [0];
    my $diff_y1 = $$p1 [1] - $$p2 [1];
    my $diff_x2 = $$p1 [0] - $$p3 [0];
    my $diff_y2 = $$p1 [1] - $$p3 [1];
    if ($$p1 [0] == $$p2 [0] == $$p3 [0]) {
        #
        # Vertical
        #
        return 2 * $diff_y1 == $diff_y2 ||
               2 * $diff_y1 == $diff_y2 ? 2 : 1
    }

    return 0 unless $diff_y1 * $diff_x2 == $diff_y2 * $diff_x1;

    return $diff_x1 == 2 * $diff_x2 ||
           $diff_x2 == 2 * $diff_x1 ? 2 : 1;
}

my %antenna;

foreach my $x (0 .. $X - 1) {
    foreach my $y (0 .. $Y - 1) {
        my $antenna = $$map [$x] [$y];
        next if $antenna eq '.';
        push @{$antenna {$antenna}} => [$x, $y];
    }
}

foreach my $x (0 .. $X - 1) {
  POINT:
    foreach my $y (0 .. $Y - 1) {
        foreach my $frequency (keys %antenna) {
            my $positions = $antenna {$frequency};
            for (my $i = 0; $i < @$positions; $i ++) {
                for (my $j = $i + 1; $j < @$positions; $j ++) {
                    my @points = @$positions [$i, $j];
                    my $r = colinear [$x, $y], @points;
                    if ($r == 2) {
                        $solution_1 ++ unless $seen_1 {$x} {$y} ++;
                    }
                    if ($r >= 1) {
                        $solution_2 ++ unless $seen_2 {$x} {$y} ++;
                    }
                }
            }
        }
    }
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
