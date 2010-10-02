#!/usr/bin/perl

use lib 'libs';
use Minecraft::NBT;

my $nbt = Minecraft::NBT->parse_from_file({file => 'level.dat', is_named => 1});
print $nbt->as_string;
