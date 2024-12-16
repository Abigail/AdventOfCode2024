#!/opt/perl/bin/perl

use 5.038;

use strict;
use warnings;
no  warnings 'syntax';

use feature 'multidimensional';
use experimental 'for_list';

@ARGV = "input" unless @ARGV;
# @ARGV = "example-1";

my ($X, $Y) = $ARGV [0] eq "input" ? (101, 103) : (11, 7);

my $X2 = int ($X / 2);
my $Y2 = int ($Y / 2);

my $solution_1 = 0;
my $solution_2 = 0;

my @robots;
my $STEPS = 100;

sub pp (@robots) {
    my %cells;
    foreach my $robot (@robots) {
        $cells {$$robot [0], $$robot [1]} ++;
    }
    for (my $y = 0; $y < $Y; $y ++) {
        for (my $x = 0; $x < $X; $x ++) {
            my $value = $cells {$x, $y};
            print $value ? $value > 9 ? '*' : $value : '.';
        }
        print "\n";
    }
}

#
# Read the input. Store each robot as [pos-x, pos-y, vel-x, vel-y]
#
while (<>) {
    /^p \s* = \s*   (\d+) \s*, \s*   (\d+) \s*
      v \s* = \s* (-?\d+) \s*, \s* (-?\d+)/x or die "Failed to parse $_";
    push @robots => [$1, $2, $3, $4];
}

#
# Given the start positions, and the number of steps, calculate the final position of each robot
#
sub run ($steps, $robots) {
    map {[($$_ [0] + $steps * $$_ [2]) % $X,
          ($$_ [1] + $steps * $$_ [3]) % $Y]} @$robots
}

#
# Given a collection of robots, calculate the security code.
#
sub code ($robots) {
    my ($q1, $q2, $q3, $q4) = (0, 0, 0, 0);
    foreach my $robot (@$robots) {
        $q1 ++ if $$robot [0] < $X2 && $$robot [1] < $Y2;
        $q2 ++ if $$robot [0] < $X2 && $$robot [1] > $Y2;
        $q3 ++ if $$robot [0] > $X2 && $$robot [1] < $Y2;
        $q4 ++ if $$robot [0] > $X2 && $$robot [1] > $Y2;
    }
    $q1 * $q2 * $q3 * $q4
}


$solution_1 = code [run $STEPS, \@robots];

#
# For some magic reason, the Christmas tree picture is the one with the lowest security code.
# Just calculate all security codes, find the lowest, and the number of steps it took to
# get to the code.
#
$solution_2 = (sort {$$a [1] <=> $$b [1] || $$a [0] <=> $$b [0]}
                map {[$_ => code [run $_, \@robots]]} 1 .. $X * $Y) [0] [0];

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
