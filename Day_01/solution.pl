#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV   = shift || "input";

my @input  = map {[split]} <>;
my @first  = sort {$a <=> $b} map {$$_ [0]} @input;
my @second = sort {$a <=> $b} map {$$_ [1]} @input;
my %count;
   $count {$_} ++ for @second;

my $solution_1 = 0;
my $solution_2 = 0;

foreach my $i (keys @first) {
    $solution_1 += abs ($first [$i] - $second [$i]);
    $solution_2 +=      $first [$i] * ($count {$first [$i]} || 0);
}


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
