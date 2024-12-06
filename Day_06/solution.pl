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

my $map = [map {[/[.^#]/g]} <>];

my $X = @{$$map [0]};
my $Y = @$map;

#
# Find the start position
#
my @guard;
my ($x_i, $y_i, $dx_i, $dy_i) = (0 ..  3);
SEARCH: foreach my $x (0 .. $X - 1) {
    foreach my $y (0 .. $Y - 1) {
        if ($$map [$x] [$y] eq '^') {
            @guard = ($x, $y, -1, 0);
            last SEARCH;
        }
    }
}


#
# Patrol the map. Return 0 if the guard loops, else return the number
# of unique places visited
#
sub patrol ($map, $x, $y, $dx, $dy) {
    my $X = @{$$map [0]};
    my $Y = @$map;
    my %visited;

    while (1) {
        return 0 if $visited {$x, $y} {$dx, $dy} ++;  # Looping
        my ($nx, $ny) = ($x + $dx, $y + $dy);
        #
        # Did we run out of bounds?
        #
        return keys %visited unless 0 <= $nx < $X && 0 <= $ny < $Y;
        #
        # Turn if we hit an obstacle, else, step.
        #
        ($x, $y, $dx, $dy) = $$map [$nx] [$ny] eq '#'
                           ? ($x,       $y,       $dy, -$dx) 
                           : ($x + $dx, $y + $dy, $dx,  $dy);
    }
}

my @places = patrol $map, @guard;

$solution_1 = @places;

my %seen;
foreach my $position (@places) {
    my ($x, $y) = split $; => $position;
    if (!$seen {$x} {$y} && 0 <= $x < $X &&
                            0 <= $y < $Y && $$map [$x] [$y] ne '#') {
        local $$map [$x] [$y] = '#';
        $solution_2 ++ unless patrol $map, @guard;
    }
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";

