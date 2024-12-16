#!/opt/perl/bin/perl

use 5.038;

use strict;
use warnings;
no  warnings 'syntax';

use feature 'multidimensional';
use experimental 'for_list';

@ARGV = "input" unless @ARGV;
# @ARGV = "example-2";

my $solution_1 = 0;
my $solution_2 = 0;

sub pp ($map, $pos_x, $pos_y) {
    for (my $x = 0; $x < @$map; $x ++) {
        for (my $y = 0; $y < @{$$map [$x]}; $y ++) {
            print $x == $pos_x && $y == $pos_y ? '@' : $$map [$x] [$y]
        }
        print "\n";
    }
    print "\n";
}

sub score ($map) {
    my $score = 0;
    for (my $x = 0; $x < @$map; $x ++) {
        for (my $y = 0; $y < @{$$map [$x]}; $y ++) {
            $score += 100 * $x + $y if $$map [$x] [$y] eq 'O';
        }
    }
    $score;
}

my $map;
while (<>) {
    last if /^\s*\n/;
    push @$map => [/./g];
}
my @commands = map {/./g} <>;

my $X =   @$map;
my $Y = @{$$map [0]};

my ($pos_x, $pos_y);
for (my $x = 1; $x < $X; $x ++) {
    for (my $y = 1; $y < $Y; $y ++) {
        if ($$map [$x] [$y] eq '@') {
            $pos_x = $x;
            $pos_y = $y;
            $$map [$x] [$y] = '.';
            last;
        }
    }
    last if $pos_x && $pos_y;
}

# pp $map, $pos_x, $pos_y;

foreach my $command (@commands) {
    my ($dir_x, $dir_y) = $command eq '<' ? ( 0, -1)
                        : $command eq '>' ? ( 0,  1)
                        : $command eq '^' ? (-1,  0)
                        : $command eq 'v' ? ( 1,  0)
                        : die "Unexpected command '$command'";
    #
    # Are we going to hit a wall, or an empty space?
    #
    my ($new_x, $new_y) = ($pos_x + $dir_x, $pos_y + $dir_y);
    while ($$map [$new_x] [$new_y] eq 'O') {
        $new_x += $dir_x;
        $new_y += $dir_y;
    }
    if ($$map [$new_x] [$new_y] eq '.') { # We can move!
        $pos_x += $dir_x;
        $pos_y += $dir_y;
        $$map [$new_x] [$new_y] = $$map [$pos_x] [$pos_y];
        $$map [$pos_x] [$pos_y] = '.';
    }
}

# pp $map, $pos_x, $pos_y;
$solution_1 = score $map;


say "Solution 1: $solution_1";
say "Solution 2: $solution_2";


__END__
