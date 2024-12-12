#!/opt/perl/bin/perl

use 5.038;

use strict;
use warnings;
no  warnings 'syntax';

use feature 'multidimensional';
use experimental 'for_list';

@ARGV = "input" unless @ARGV;

my $map = [map {[/[A-Z]/g, "."]} <>];
push @$map => [(".") x @{$$map [0]}];
my $X = @$map - 1;
my $Y = @{$$map [0]} - 1;

my $solution_1 = 0;
my $solution_2 = 0;


my $TOP    = 0;
my $RIGHT  = $TOP    + 1;
my $BOTTOM = $RIGHT  + 1;
my $LEFT   = $BOTTOM + 1;

sub process_region ($map, $x, $y) {
    my $X = 0;
    my $Y = 1;
    my $cell = $$map [$x] [$y];
    my %region;
    my @boundary;

    #
    # Do a floodfill to find the region. Mark the boundaries, and denote
    # whether they're top, right, bottom, or left boundaries.
    #
    my @todo = ([$x, $y]);
    while (@todo) {
        my ($x, $y) = @{shift @todo};
        next if $region {$x} {$y} ++;
        foreach my ($nx, $ny) ($x - 1, $y, $x, $y - 1, $x + 1, $y, $x, $y + 1) {
            my $neighbour = $$map [$nx] [$ny];
            if ($neighbour ne $cell) {
                #
                # If the neighbour is different, we have a boundary.
                #
                my $key = $nx > $x ? $TOP   : $nx < $x ? $BOTTOM
                        : $ny > $y ? $RIGHT :            $LEFT;
                push @{$boundary [$key]} => [$x, $y];
            }
            else {
                #
                # Else, process the neighbour
                #
                push @todo => [$nx, $ny]
            }
        }
    }

    #
    # We now have the region. Mark them as out of bounds, and calculate the area
    #
    my $area = 0;
    foreach my $x (keys %region) {
        foreach my $y (keys %{$region {$x}}) {
            $area ++;
            $$map [$x] [$y] = ".";
        }
    }

    #
    # Calculate the length of the boundary
    #
    my $boundary = 0;
    $boundary += @{$boundary [$_]} for keys @boundary;

    #
    # Find the segments:
    #   - First we sort the set, for top/bottom, first on x, then on y;
    #                            for right/left, first on y, then on x;
    #   - Then we collapse the boundaries: as long as the first two boundaries
    #     have the same main coordinate value, and differ by one in the other,
    #     they can be collapsed to one. Shift off a collapsed boundary,
    #     and count it as a segment.
    #
    my $segments = 0;
    for my $key ($TOP .. $LEFT) {
        my @set = @{$boundary [$key]};
        my $index  = $key == $TOP || $key == $BOTTOM ? $X : $Y;
        my $oindex = 1 - $index;
        @set = sort {$$a [$index] <=> $$b [$index] || $$a [$oindex] <=> $$b [$oindex]} @set;
        while (@set) {
            while (@set > 1 && $set [0] [$index]      == $set [1] [$index] &&
                               $set [0] [$oindex] + 1 == $set [1] [$oindex]) {
                shift @set;
            }
            $segments ++;
            shift @set;
        }
    }
    return ($area * $boundary, $area * $segments);
}


for (my $x = 0; $x < $X; $x ++) {
    for (my $y = 0; $y < $Y; $y ++) {
        my $cell = $$map [$x] [$y];
        next if $cell eq '.';  # Already processed
        my ($s1, $s2) = process_region ($map, $x, $y);
        $solution_1 += $s1;
        $solution_2 += $s2;
    }
}



say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
