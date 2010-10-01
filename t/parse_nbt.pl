#!/usr/bin/perl

use lib 'libs';
use Minecraft::NBT;

my $FH;
open $FH, "level.nbt" or die "Could not open file";
local $\;
my $nbt = Minecraft::NBT->parse_from_fh({fh => $FH, is_named => 1});
close $FH;
print $nbt->as_string;
