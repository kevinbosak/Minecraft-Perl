#!/usr/bin/perl

use Minecraft::NBT;
use Minecraft::Util;
use Data::Dumper;

$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

#my $min_x = -10;
#my $max_x = 10;
#my $min_z = -20;
#my $max_z = 0;
my $min_x = -49;
my $max_x = 30;
my $min_z = -44;
my $max_z = 13;

my $x_offset = 0 - $min_x*16;
my $z_offset = 0 - $min_z*16;

my $height_data = [];
my $empty_chunk = [];

for my $chunk_x ($min_x .. $max_x) {
    for my $chunk_z ($min_z..$max_z) {
    print "Chunk $chunk_x, $chunk_z\n";
        my $chunk = Minecraft::Util->load_chunk_from_file({path => 'world', chunk_x => $chunk_x, chunk_z => $chunk_z});

        for my $z (0..15) {
            my @stuff = map {sprintf('%02d', $_)} @{$chunk->height_map}[$z*16 .. 16*$z+15] if $chunk;
            my $z_index = $chunk_z*16 + $z;
            for $x (0..15) {
                my $x_index = $chunk_x*16 + $x;
                $height_data->[$z_index + $z_offset]->[$x_index + $x_offset] = @stuff ?  $stuff[$x] : 0;
            }
        }
    }
}

open FH, ">height.map" or die "Could not open";
print FH Dumper $height_data;
close FH;
