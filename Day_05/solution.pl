#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "input";

my %rules;

my $solution_1 = 0;
my $solution_2 = 0;

#
# We will store the rules of the form X|Y as
#    $rules {X} {Y} = -1 and
#    $rules {Y} {X} =  1
# This uses the same rules as "sort" uses them, if the first element
# should sort before the second, -1 (or any other negative value) indicates
# it does; if the first element should sort after the second, 1 (or any
# other positive value) should be returned.
#

while (<>) {
    last unless /^([0-9]+)\|([0-9]+)/;
    $rules {$1} {$2} = -($rules {$2} {$1} = 1);
}

#
# Read in the set of page numbers, and sort them. If the sorted list
# equals the original one, the original list was in the right order, and
# should be counted towards the answer of part 1. Else, the sorted list
# should be counted towards the answer of part 2.
#
while (<>) {
    my @sort = sort {$rules {$a} {$b}} my @list = /[0-9]+/g;
    if ("@list" eq "@sort") {$solution_1 += $list [@list / 2]} 
    else                    {$solution_2 += $sort [@sort / 2]}
}


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
