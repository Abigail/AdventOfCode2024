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

my $map = [map {[/./g]} <>];

my ($sx, $sy, $ex, $ey);

for (my $x = 1; $x < @$map - 1; $x ++) {
    for (my $y = 1; $y < @{$$map [$x]} - 1; $y ++) {
        ($sx, $sy) = ($x, $y) if $$map [$x] [$y] eq 'S';
        ($ex, $ey) = ($x, $y) if $$map [$x] [$y] eq 'E';
    }
}
 
#
# Use Dijkstra to find the cheapest path from start to finish, while keeping
# track of all the possible cells visited to reach a certain point in the
# cheapest way.
#
#             $x,  $y,  $dx, $dy, $score, $px, $py, $pdx, $pdy
my @heads = ([$sx, $sy, 0,   1,   0,      0,   0,   0,    0]);
my %best;  # {$x, $y, $dx, $dy -> [$score, $cells]}
$best {$sx, $sy, 0, 0} = [0, {}];
my $end_score;
while (@heads) {
    my ($x, $y, $dx, $dy, $score, $px, $py, $pdx, $pdy) = @{shift @heads};
    my $val = $$map [$x] [$y];
    last if $end_score && $score > $end_score; 
    next if $val eq '#';   # Cannot continue through a wall

    my $cell_score = $best {$x, $y, $dx, $dy} [0] || 0;
    next if $cell_score && $score > $cell_score;  # Found a better path.
    $best {$x, $y, $dx, $dy} [0] ||= $score;
    $best {$x, $y, $dx, $dy} [1] ||= {};
    #
    # Add the cells of the previous position; 
    #
    foreach my $cell (keys %{$best {$px, $py, $pdx, $pdy} [1]}) {
        $best {$x, $y, $dx, $dy} [1] {$cell} ++;
    }
    #
    # And add the current position
    #
    $best {$x, $y, $dx, $dy} [1] {$x, $y, $dx, $dy} ++;

    $end_score = $score, next if $val eq 'E';  # Reached the end
    next if $score && $score == $cell_score;

    #
    # Not a wall, and not finished. We can do one of three things:
    #   - Move one step, increase the score by 1
    #   - Turn clockwise, increase the score by 1000
    #   - Turn counterclockwise, increase the score by 1000
    #
    @heads = sort {$$a [4] <=> $$b [4]} @heads,
         [$x + $dx, $y + $dy,  $dx,  $dy, $score + 1,    $x, $y, $dx, $dy],
         [$x,       $y,        $dy, -$dx, $score + 1000, $x, $y, $dx, $dy],
         [$x,       $y,       -$dy,  $dx, $score + 1000, $x, $y, $dx, $dy];

}

my %cells;
foreach my ($dx, $dy) (0, 1, 0, -1, 1, 0, -1, 0) {
    next unless $best {$ex, $ey, $dx, $dy} &&
                $best {$ex, $ey, $dx, $dy} [0] == $end_score;
    my $cells = $best {$ex, $ey, $dx, $dy} [1];

    foreach my $cell (keys %$cells) {
        my ($x, $y, $dx, $dy) = split $; => $cell;
        $cells {$x, $y} ++;
    }
}

$solution_1 = $end_score;
$solution_2 = keys %cells;


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
