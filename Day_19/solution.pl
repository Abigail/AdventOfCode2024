#!/opt/perl/bin/perl

use 5.038;

use strict;
use warnings;
no  warnings 'syntax';

use feature 'multidimensional';
use experimental 'for_list';

use List::Util qw [min max];

@ARGV = "input" unless @ARGV;

my $solution_1 = 0;
my $solution_2 = 0;

my %towels = map {$_ => 1} <> =~ /[a-z]+/g;
<>;

my $min = min map {length} keys %towels;
my $max = max map {length} keys %towels;

sub count;
sub count ($pattern) {
    state $cache = {};

    $$cache {$pattern} //= do {
        my $count = 0;
        if ($pattern) {
            for my $l ($min .. $max) {
                last if $l > length $pattern;
                my $head = substr $pattern, 0, $l;
                my $tail = substr $pattern,    $l;
                $count  += count $tail if $towels {$head};
            }
        }
        else {
            $count = 1;
        }
        $count;
    }
}


while (my $pattern = <>) {
    chomp $pattern;
    my $count = count $pattern;
    $solution_1 ++ if $count;
    $solution_2 +=    $count;
}

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
