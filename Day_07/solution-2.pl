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

sub results;
sub results ($part, $first = undef, $second = undef, @rest) {
    return !defined $first  ? ()
         : !defined $second ? $first
         : (                  results ($part, $first + $second, @rest),
                              results ($part, $first * $second, @rest),
            $part == 1 ? () : results ($part, $first . $second, @rest),
     );
}

while (<>) {
    my ($total, @parts) = /[0-9]+/g;
    $solution_1 += $total if grep {$_ == $total} results 1, @parts;
    $solution_2 += $total if grep {$_ == $total} results 2, @parts;
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
