#!/usr/bin/perl

use lib '../libs';

use Minecraft::NBT;
use Minecraft::Util;
use Data::Dumper;

$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 0;

#my $min_x = -10;
#my $max_x = 10;
#my $min_z = -20;
#my $max_z = 0;
my $min_x = -30;
my $max_x = 30;
my $min_z = -30;
my $max_z = 30;

my $x_offset = 0 - $min_x*16;
my $z_offset = 0 - $min_z*16;

my $height_data = [];
my $empty_chunk = [];

my $loaded_regions = {};

for my $chunk_x ($min_x .. $max_x) {
    for my $chunk_z ($min_z..$max_z) {
    print "Chunk $chunk_x, $chunk_z\n";
        my ($region_x, $region_z) = Minecraft::Util::get_chunk_region({chunk_x => $chunk_x, chunk_z => $chunk_z});
        my $region = $loaded_regions->{$region_x . '_' . $region_z};
        if (!$region) {
            $region = Minecraft::Util::load_region_from_file({
                    path => '/Users/kevinbosak/Library/Application Support/minecraft/saves/Bob/region/',
                    region_x => $region_x,
                    region_z => $region_z,
                });
            die "Could not load region $region_x,$region_z" unless $region;
            $loaded_regions->{$region_x . '_' . $region_z} = $region;
        }
        my $chunk = $region->get_chunk({absolute_x => $chunk_x, absolute_z => $chunk_z});

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
