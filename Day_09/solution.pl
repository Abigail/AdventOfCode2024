#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

my $solution_1 = 0;
my $solution_2 = 0;

@ARGV = shift // "input";

my $FILE = 1;
my $FREE = 2;
my $TYPE = 0;
my $LEN  = $TYPE + 1;
my $ID   = $LEN  + 1;
my $HEAD = 0;
my $TAIL = -1;


sub sum (@map) {
    my ($pos, $sum) = (0, 0);
    foreach my $file (@map) {
        $sum += $pos ++ * $$file [$ID] for 1 .. $$file [$LEN];
    }
    return $sum;
}


#
# Read in the input. Store the blocks as 3-tuples:
#    * Its type ($FILE or $FREE)
#    * Its length
#    * Its id (use 0 for free blocks)
# Copy this for part 2
#
my @map  = <> =~ /./g;
my @map2 = map {[@$_]}
my @map1 = map {$_  % 2 ? [$FREE => $map [$_], 0]
                        : [$FILE => $map [$_], int ($_ / 2)]} keys @map;


#
# Part 1: fill in the blanks, creating a new layout. 
#
my @new_map1;
while (@map1) {
    #
    # Remove trailing free space
    #
    if ($map1 [$TAIL] [$TYPE] == $FREE) {pop @map1; next}
    #
    # Discard any zero blocks
    #
    if ($map1 [$HEAD] [$LEN] == 0) {shift @map1; next}
    #
    # Copy leading files
    #
    if ($map1 [$HEAD] [$TYPE] == $FILE) {push @new_map1 => shift @map1; next}
    #
    # Now, we have free space. Fill in the space, considering two cases
    #
    if ($map1 [$HEAD] [$LEN] >= $map1 [$TAIL] [$LEN]) {
        #
        # We can fit the entire file. Update the free space, copy the file
        #
        $map1 [$HEAD] [$LEN] -= $map1 [$TAIL] [$LEN];
        push @new_map1 => pop @map1;
    }
    else {
        #
        # Only a partial file. Discard leading free space. Update
        # the length of the file at the end. Create a new file at
        # the new map
        #
        push @new_map1 => [$FILE => $map1 [$HEAD] [$LEN], $map1 [$TAIL] [$ID]];
        $map1 [$TAIL] [$LEN] -= $map1 [$HEAD] [$LEN];
        shift @map1;
    }
}

#
# Part 2: fill in the blanks as well; this time, in situ
#
my @new_map2;
MAP2: while (@map2) {
    #
    # Get rid of leading 0 length blocks
    #
    if ($map2 [$HEAD] [$LEN] == 0) {shift @map2; next;}
    #
    # Copy leading files
    #
    if ($map2 [$HEAD] [$TYPE] == $FILE) {push @new_map2 => shift @map2; next}
    #
    # If the leading block is free space, find the last file in @map2 which fits
    #
    for (my $i = @map2 - 1; $i >= 0; $i --) {
        next if $map2 [$i] [$TYPE] == $FREE ||
                $map2 [$i] [$LEN] > $map2 [$HEAD] [$LEN];
        #
        # Now we have a file which fits. Copy to the new map, turn in
        # to free space in the map, collapsing freespace into one, if any,
        # and reduce the leading free space.
        #
        push @new_map2 => [@{$map2 [$i]}];  # Copy!

        #
        # Reduce free block size
        #
        $map2 [$HEAD] [$LEN] -= $map2 [$i] [$LEN];

        #
        # Make the copied block free; hence its ID will be 0
        #
        $map2 [$i] [$TYPE] = $FREE;
        $map2 [$i] [$ID]   = 0;

        next MAP2;
    }
    #
    # Could not find a file to fit, copy free blocks.
    #
    push @new_map2 => shift @map2;
}

$solution_1 = sum @new_map1;
$solution_2 = sum @new_map2;

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
