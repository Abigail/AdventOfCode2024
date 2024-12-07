#!/opt/perl/bin/perl

use 5.032;

use strict;
use warnings;
no  warnings 'syntax';

use experimental 'signatures';
use experimental 'lexical_subs';

@ARGV = shift // "input";

my $input   = [map {[split //]} <>];  # Includes "\n"

my $skip_ns = @{$$input [0]} - 1;
my $skip_nw =    $skip_ns + 1;
my $skip_ne =    $skip_ns - 1;

$_ = join "" => map {join "" => @$_} @$input;
my $solution_1 = 0;
my $solution_2 = 0;

/ (?:
      XMAS                                    | # W -> E
      X.{$skip_ns}M.{$skip_ns}A.{$skip_ns}S   | # N -> S
      X.{$skip_nw}M.{$skip_nw}A.{$skip_nw}S   | # NW -> SE
      X.{$skip_ne}M.{$skip_ne}A.{$skip_ne}S   | # NE -> SW
      SAMX                                    | # E -> W
      S.{$skip_ns}A.{$skip_ns}M.{$skip_ns}X   | # S -> N
      S.{$skip_nw}A.{$skip_nw}M.{$skip_nw}X   | # NW -> SE
      S.{$skip_ne}A.{$skip_ne}M.{$skip_ne}X     # NE -> SW
  )
  (?{$solution_1 ++}) (*FAIL)
/xs;


/ (?: M.M .{$skip_ne} A .{$skip_ne} S.S |
      M.S .{$skip_ne} A .{$skip_ne} M.S |
      S.M .{$skip_ne} A .{$skip_ne} S.M |
      S.S .{$skip_ne} A .{$skip_ne} M.M )
  (?{$solution_2 ++}) (*FAIL)
/xs;

say "Solution 1: $solution_1";
say "Solution 2: $solution_2";
