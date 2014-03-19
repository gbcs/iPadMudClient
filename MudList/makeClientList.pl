#!/usr/bin/perl -w

use strict;

my $F1;
my $F2;

open $F1, "<mudList";
open $F2, ">mudClientList";

while (my $line = <$F1>) {

$line =~ /url\=telnet\:\/\/(.+)\:(.+)\"\ target/;

my $server = $1;
my $port = $2;

$line =~ /\>telnet\:\ (.+)\<\/a\>/;

my $name = $1;
 
print $F2 "$name~$server~$port\n";

}

close $F1;
close $F2;

