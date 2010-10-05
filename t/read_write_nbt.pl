#!/usr/bin/perl

use Minecraft::NBT;
use Minecraft::Util;

#my $FH;
#open $FH, "bigtest.nbt" or die "Could not open file";
#local $\;
my $nbt = Minecraft::NBT->parse_from_file({file => 'level.dat', is_named => 1});
#close $FH;

my $data = $nbt->as_nbt;

#open $OUT, ">out.nbt" or die "Could not open file";
#binmode $OUT;
#print $OUT $data;
#close $OUT;

my $FH = Minecraft::Util::get_write_fh('out.dat');
print $FH $data;
close $FH;
bin
