#!/usr/bin/perl

use Minecraft::NBT;
use Minecraft::Util;
use Minecraft::Map::Util;
use Data::Dumper;

my $max_x = 1;
my $max_z = 1;

my $height_data = [];

for my $chunk_x (0 .. $max_x) {
    for my $chunk_z (0..$max_z) {
    print "Chunk $chunk_x, $chunk_z\n";
        my $chunk = Minecraft::Map::Util->load_chunk_from_file({path => 'world', chunk_x => $chunk_x, chunk_z => $chunk_z});

        for my $z (0..15) {
            my @stuff = map {sprintf('%02d', $_)} @{$chunk->height_map}[$z*16 .. 16*$z+15];
            my $z_index = $chunk_z*16 + $z;
            for $x (0..15) {
                my $x_index = $chunk_x*16 + $x;
                $height_data->[$z_index]->[$x_index] = $stuff[$x];
            }
        }
    }
}

for my $row (@$height_data) {
    for my $height (@$row) {
        print "$height ";
    }
    print "\n";
}
