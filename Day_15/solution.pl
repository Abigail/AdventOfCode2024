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

sub pp ($map, $pos_x, $pos_y) {
    for (my $x = 0; $x < @$map; $x ++) {
        for (my $y = 0; $y < @{$$map [$x]}; $y ++) {
            print $x == $pos_x && $y == $pos_y ? '@' : $$map [$x] [$y]
        }
        print "\n";
    }
    print "\n";
}

sub score ($map) {
    my $score = 0;
    for (my $x = 0; $x < @$map; $x ++) {
        for (my $y = 0; $y < @{$$map [$x]}; $y ++) {
            $score += 100 * $x + $y if $$map [$x] [$y] eq 'O' || $$map [$x] [$y] eq '[';
        }
    }
    $score;
}

sub find_pos ($map) {
    my ($pos_x, $pos_y);
    for (my $x = 1; $x < @$map; $x ++) {
        for (my $y = 1; $y < @{$$map [$x]}; $y ++) {
            if ($$map [$x] [$y] eq '@') {
                $$map [$x] [$y] = '.';
                return ($x, $y);
            }
        }
    }
}

my $map1;
my $map2;
while (<>) {
    last if /^\s*\n/;
    push @$map1 => [/./g];
    push @$map2 => [map {$_ eq '#' ? ('#', '#')
                       : $_ eq 'O' ? ('[', ']')
                       : $_ eq '.' ? ('.', '.')
                       : $_ eq '@' ? ('@', '.')
                       : die "Unexpected value '$_'"} /./g];
}
my @commands = map {/./g} <>;

my ($pos1_x, $pos1_y) = find_pos $map1;
my ($pos2_x, $pos2_y) = find_pos $map2;

sub move ($map, $command, $pos_x, $pos_y) {
    my ($dir_x, $dir_y) = $command eq '<' ? ( 0, -1)
                        : $command eq '>' ? ( 0,  1)
                        : $command eq '^' ? (-1,  0)
                        : $command eq 'v' ? ( 1,  0)
                        : die "Unexpected command '$command'";
    my @front;  # Cells which should not be walls. If they are all empty, we can move.
    my @blocks; # Blocks which need to be moved a single space.

    @front = ([$pos_x + $dir_x, $pos_y + $dir_y]);  # Initially, just one cell.

    while (1) {
        #
        # Process front. If any cell in the front is a wall, we cannot move.
        # Any block in the front becomes part of the new front. If there are
        # no blocks in the front, we can move (exit the loop).
        #
        my @new_front;
        my %done;
        while (@front) {
            my $cell = shift @front;
            my ($x, $y) = @$cell;
            next if $done {$x} {$y} ++;
            my $val = $$map [$x] [$y];
            if ($val eq '#') {
                return ($map, $pos_x, $pos_y);
                print "\n";
            }
            unless ($val eq '.') {
                push @blocks    => [$x,          $y];
                push @new_front => [$x + $dir_x, $y + $dir_y];
            }

            #
            # If we're pushing vertically, and we're pushing on half a block,
            # we need to consider the other half as well.
            #
            if ($dir_y == 0) {
                push @front => [$x, $y - 1] if $val eq ']';
                push @front => [$x, $y + 1] if $val eq '[';
            }
        }
        #
        # If the new front is empty, we can move.
        #
        last unless @new_front;

        #
        # We've finished calculating the new front.
        #
        @front = @new_front;
    }

    #
    # New we can perform the move. Process @block back to front ought to work.
    #
    foreach my $block (reverse @blocks) {
        my ($x, $y)   = @$block;
        my ($nx, $ny) = ($x + $dir_x, $y + $dir_y);
        $$map [$nx] [$ny] = $$map [$x] [$y];
        $$map [$x] [$y] = ".";
    }
    $pos_x += $dir_x;
    $pos_y += $dir_y;

    return ($map, $pos_x, $pos_y);
}

($map1, $pos1_x, $pos1_y) = move ($map1, $_, $pos1_x, $pos1_y) for @commands;
$solution_1 = score $map1;

($map2, $pos2_x, $pos2_y) = move ($map2, $_, $pos2_x, $pos2_y) for @commands;
$solution_2 = score $map2;


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
