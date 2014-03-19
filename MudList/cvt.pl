#!/usr/bin/perl -w

use strict;

while (my $line = <>) {
 $line =~ s/\'(.+)//;
 $line =~ s/\:SQ\:/\'/g; 
print $line;
}
