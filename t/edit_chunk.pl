#!/usr/bin/perl

use warnings;
use strict;

use Minecraft::NBT;
use Minecraft::NBT::Compound;
use Minecraft::Util;
use Minecraft::Map::Util;
use Data::Dumper;

my $chunk_x = 0;
my $chunk_z = 0;

my $terrain_data = [];
my $empty_chunk = [];

print "Chunk $chunk_x, $chunk_z\n";
my $chunk = Minecraft::Map::Util->load_chunk_from_file({path => 'world', chunk_x => $chunk_x, chunk_z => $chunk_z});
my $blocks = $chunk->blocks;
$blocks->[19] = 0;
for (20..110) {
    $blocks->[$_] = 12;
}
for my $x (0..15) {
    for my $z (0..15) {
        for my $y (60..80) {
            my $i = $y + $z*128 + $x*128*16;
            if ($x > 0 && $x < 15 && $z > 0 && $z < 15) {
                $blocks->[$i] = 0;
            } else {
                $blocks->[$i] = 49;
            }
        }
    }
}

#$chunk->blocks($blocks); #trigger the 'set' trigger to update the chunk nbt
my $chunk_data = $chunk->chunk_nbt_data;

my $block_data = pack('C*', @$blocks);
$chunk_data->get_child_by_name('Blocks')->payload($block_data);

my $nbt = Minecraft::NBT::Compound->new({name => '', payload => [$chunk_data]});

my $raw_nbt = $nbt->as_nbt;

my $FH = Minecraft::Util::get_write_fh('chunk.gz');
print $FH $raw_nbt;
close $FH;
