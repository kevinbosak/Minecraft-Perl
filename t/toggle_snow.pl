#!/usr/bin/perl

use lib 'libs';
use Minecraft::NBT;

my $FH;
open $FH, "level.nbt" or die "Could not open file";
local $\;
my $nbt = Minecraft::NBT->parse_from_fh({fh => $FH, is_named => 1});
close $FH;

$nbt->payload->[0]->payload->[5]->payload(1);
print $nbt->as_string;

my $data = $nbt->as_nbt;

open $OUT, ">level.nbt.new" or die "Could not open file";
binmode $OUT;
print $OUT $data;
close $OUT;
