#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

use List::Util 'sum';

@ARGV = shift // "input";

undef $/;
my $stones; $$stones {$_} ++ for <> =~ /[0-9]+/g;

sub blink ($set) {
    my $new;
    while (my ($value, $count) = each %$set) {
        if (length ($value) % 2 == 0) {
            $$new {int substr ($value, 0, length ($value) / 2)} += $count;
            $$new {int substr ($value,    length ($value) / 2)} += $count;
        }
        else {
            $$new {$value * 2024 + ($value ? 0 : 1)}            += $count;
        }
    }
    $new;
}

$stones = blink $stones for  1 .. 25;
say "Solution 1: ", sum values %$stones;

$stones = blink $stones for 26 .. 75;
say "Solution 2: ", sum values %$stones;
