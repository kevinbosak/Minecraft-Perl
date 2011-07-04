#!/usr/bin/perl

use lib '../libs';
use Minecraft::NBT;

my $file = shift;
die "Must specify file" unless $file;

my $nbt = Minecraft::NBT->parse_from_file({file => $file, is_named => 1, is_compressed => 1});
print $nbt->as_string;
