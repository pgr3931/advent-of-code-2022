#!/usr/bin/perl
use strict;
use warnings;

use Path::Tiny;
use autodie;

my $dir = path("./");
my $file = $dir->child("input.txt");
my $content = $file->slurp_utf8();
my $file_handle = $file->openr_utf8();

my $x = 1;
my $cycle = 0;
my $significantCycle = 20;
my $signalStrength = 0;
my $row = 0;

#  Part one
sub Cycle {
    $cycle += 1;
    if($cycle == $significantCycle && $significantCycle <= 220){
        $signalStrength += $significantCycle * $x;
        $significantCycle += 40;
    }
}

# Part two
sub RenderCycle {  
    if($cycle != 0 && $cycle % 40 == 0){
        print "\n";
        $row += 40;
    }

    my $pixel = $cycle - $row;

    if($x == $pixel || $x - 1 == $pixel || $x + 1 == $pixel){
        print "#";
    } else {
        print ".";
    }

    Cycle();
}

while(my $line = $file_handle->getline()) {
    chomp($line);
    $line =~ s/\r//g;

    if ($line eq "noop"){
        RenderCycle();
        next;
    }

    RenderCycle();
    RenderCycle();
    my @spl = split(' ', $line);
    $x += $spl[1];
}

print "\n\n$signalStrength";