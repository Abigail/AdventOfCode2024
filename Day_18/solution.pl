#!/opt/perl/bin/perl

use 5.038;

use strict;
use warnings;
no  warnings 'syntax';

use feature 'multidimensional';
use experimental 'for_list';

@ARGV = "input" unless @ARGV;
# @ARGV = "example-1";

my $is_example = $ARGV [0] =~ /example/;

my $solution_1 = 0;
my $solution_2 = 0;

my $X     = $is_example ?  7 :   71;
my $Y     = $X;
my $drops = $is_example ? 12 : 1024;

my @bytes = map {[/\d+/g]} <>;


#
# Find the length of the shortest path using BFS. Return -1 if no
# such path exists.
#
sub solve ($bytes, $drops) {
    my %walls; # Wall or been here.
    $walls {$$_ [0]} {$$_ [1]} ++ for @$bytes [0 .. $drops - 1];
    my @queue = ([0, 0, 0]);  # Steps, $X, $Y
    while (@queue) {
        my ($steps, $x, $y) = @{shift @queue};
        return $steps if $x == $X - 1 && $y == $Y - 1;
        next if $x < 0 || $x >= $X || $y < 0 || $y >= $Y || $walls {$x} {$y} ++;
        foreach my ($dx, $dy) (1, 0, -1, 0, 0, 1, 0, -1) {
            push @queue => [$steps + 1, $x + $dx, $y + $dy];
        }
    }
    return -1;
}

$solution_1 = solve \@bytes, $drops;


#
# Use a binary search to find the answer to part 2.
#
my ($low, $high) = ($drops, 1 + scalar @bytes);

while ($low < $high - 1) {
    my $mid = int (($low + $high) / 2);
    my $l   = solve \@bytes, $mid;
    if ($l > 0) {$low = $mid}
    else {$high = $mid}
}

$solution_2 = join "," => @{$bytes [$high - 1]};

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
