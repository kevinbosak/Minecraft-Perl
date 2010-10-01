#!/usr/bin/perl

use lib 'libs';
use Minecraft::NBT;

my $FH;
open $FH, "bigtest.nbt" or die "Could not open file";
local $\;
my $nbt = Minecraft::NBT->parse_from_fh({fh => $FH, is_named => 1});
close $FH;

my $data = $nbt->as_nbt;

open $OUT, ">out.nbt" or die "Could not open file";
binmode $OUT;
print $OUT $data;
close $OUT;
