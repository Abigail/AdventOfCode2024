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


#
# Read in the input. Store the blocks as 3-tuples:
#    * Its type ($FILE or $FREE)
#    * Its length
#    * Its id (use 0 for free blocks)
#
my @input  = <> =~ /./g;
my ($sum, $pos);

foreach my $part (1, 2) {
    my @map = map {$_  % 2 ? [$FREE => $input [$_], 0]
                           : [$FILE => $input [$_], int ($_ / 2)]} keys @input;
    $sum = $pos = 0;
    sub add_score ($blk) {$sum += $pos ++ * $$blk [$ID] for 1 .. $$blk [$LEN];}

  MAP:
    while (@map) {
        #
        # Remove trailing free space
        #
        if ($map [$TAIL] [$TYPE] == $FREE) {pop @map; next}
        #
        # Discard any leading zero blocks
        #
        if ($map [$HEAD] [$LEN] == 0) {shift @map; next}
        #
        # A leading file stays that way in the final disk map, so
        # we can add it to the score.
        #
        if ($map [$HEAD] [$TYPE] == $FILE) {add_score shift @map; next}

        #
        # Now, we have leading free space. How we deal with that, depends on 
        # the part of the puzzle we're solving.
        #
        if ($part == 1) {
            if ($map [$HEAD] [$LEN] >= $map [$TAIL] [$LEN]) {
                #
                # We can fit the entire file. Update the free space, 
                # calculate the score of the file, which will be
                # removed.
                #
                $map [$HEAD] [$LEN] -= $map [$TAIL] [$LEN];
                add_score pop @map;
            }
            else {
                #
                # Only a partial fit. Discard leading free space. Update
                # the length of the file at the end. Update the score using
                # the part of the file that fits the space.
                #
                add_score [$FILE => $map [$HEAD] [$LEN], $map [$TAIL] [$ID]];
                $map [$TAIL] [$LEN] -= $map [$HEAD] [$LEN];
                shift @map;
            }
        }
        else {
            #
            # Find the last file which will fit
            #
            for (my $i = @map - 1; $i >= 0; $i --) {
                next if $map [$i] [$TYPE] == $FREE ||
                        $map [$i] [$LEN] > $map [$HEAD] [$LEN];
                #
                # Now we have a file which fits. Add it to the score, turn it
                # to free space on the map, and reduce the leading free space.
                #
                add_score $map [$i];

                #
                # Reduce free block size
                #
                $map [$HEAD] [$LEN] -= $map [$i] [$LEN];

                #
                # Make the copied block free; hence its ID will be 0
                #
                $map [$i] [$TYPE] = $FREE;
                $map [$i] [$ID]   = 0;

                next MAP;
            }
            #
            # Could not find a file to fit, score the free block.
            #
            add_score shift @map;
        }
    }
    say "Solution $part: $sum"
}
