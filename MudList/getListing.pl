#!/bin/perl -w

use strict;
my $F1;
my $F2;

open $F1, ">detailText";
open $F2, "<inputText";
while (my $line = <$F2>) {
print $line;
chomp $line;  
my $cmd = 'http://www.mudconnect.com/cgi-bin/adv_search.cgi?Mode=MUD2&mud=' . $line;
print $F1 `curl "$cmd"`;
sleep 1;
}

close $F1;
