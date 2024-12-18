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

my ($adv, $bxl, $bst, $jnz, $bxc, $out, $bdv, $cdv) = (0 .. 7);

undef $/;
my $input = <>;
my ($A)       = $input =~ /Register A:\s+([0-9]+)/;
my ($B)       = $input =~ /Register B:\s+([0-9]+)/;
my ($C)       = $input =~ /Register C:\s+([0-9]+)/;
my ($program) = $input =~ /Program:\s+([0-9,]+)/;
my  @program  = split /,/ => $program;

sub run_program ($A, $B, $C, $program, $is_quine = 0) {
    my sub combo ($operand) {
        0 <= $operand <= 3 ? $operand
      :      $operand == 4 ? $A
      :      $operand == 5 ? $B
      :      $operand == 6 ? $C
      :      $operand == 7 ? die "Illegal instruction"
      :                      die "Unexpected operand '$operand'"
    }

    my @out;
    my $iv = 0;

    while (0 <= $iv < @$program - 1) {
        my ($inst, $operand) = @$program [$iv, $iv + 1];
        my $combo = combo ($operand);
        $iv += 2;

        if ($inst == $adv) {$A  = int ($A / 2 ** $combo)}
        if ($inst == $bxl) {$B  = $B ^ $operand}
        if ($inst == $bst) {$B  = $combo % 8}
        if ($inst == $jnz) {$iv = $operand if $A}
        if ($inst == $bxc) {$B  = $B ^ $C}
        if ($inst == $bdv) {$B  = int ($A / 2 ** $combo)}
        if ($inst == $cdv) {$C  = int ($A / 2 ** $combo)}
        if ($inst == $out) {push @out => $combo % 8;}
    }
    join "," => @out;
}

$solution_1 = run_program ($A, $B, $C, \@program);

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
