#!/usr/bin/perl

use warnings;
use strict;

use Minecraft::NBT;
use Minecraft::NBT::Compound;
use Minecraft::Util;
use Data::Dumper;

my $chunk_x = 0;
my $chunk_z = 0;

my $terrain_data = [];
my $empty_chunk = [];

print "Chunk $chunk_x, $chunk_z\n";
my $chunk = Minecraft::Util->load_chunk_from_file({path => 'world', chunk_x => $chunk_x, chunk_z => $chunk_z});
my $blocks = $chunk->sky_light;
#warn $blocks->[19];
#$blocks->[19] = '0000';
#for (20..110) {
#    $blocks->[$_] = 12;
#}
#for my $x (0..15) {
#    for my $z (0..15) {
#        for my $y (60..80) {
#            my $i = $y + $z*128 + $x*128*16;
#            if ($x > 0 && $x < 15 && $z > 0 && $z < 15) {
#                $blocks->[$i] = 0;
#            } else {
#                $blocks->[$i] = 49;
#            }
#        }
#    }
#}

$chunk->sky_light($blocks); #trigger the 'set' trigger to update the chunk nbt

my $raw_nbt = $chunk->as_nbt_data;
my $FH = Minecraft::Util::get_write_fh('chunk.gz');
print $FH $raw_nbt;
close $FH;
