#!/usr/bin/perl

open FH, "session.lock";
local $\;
my $data = <FH>;
close FH;

my( $time ) = unpack( 'q>*', $data );
print "$time\n";
$time /= 1000;
my ($sec, $min, $hr, $day, $mon, $yr) = localtime($time);
$mon++;
$yr += 1900;
warn "$yr-$mon-$day $hr:$min:$sec";

#for my $byte (split(//, $data)) {
#}
