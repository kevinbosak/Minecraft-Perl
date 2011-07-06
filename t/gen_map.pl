#!/usr/bin/perl

use lib '../libs/';

use Minecraft::NBT;
use Minecraft::Util;
use Minecraft::Map::Region;
use Data::Dumper;
use Getopt::Long;
use Image::Magick;

my $time = time();

my ($is_nether, $min_x, $min_z, $max_x, $max_z, $outfile, $full_path) = (0,0,0,1,1,'map.png');
my $help;
my $block_types;
my $hide_types;

my $getopt_result = GetOptions(
        'min_x|x_min=s'              => \$min_x,
        'min_z|z_min=s'              => \$min_z,
        'max_x|x|x_max=s'            => \$max_x,
        'max_z|z|z_max=s'            => \$max_z,
        'file|outfile=s'             => \$outfile,
        'path=s'                     => \$full_path,
        'help'                       => \$help,
        'blocks|block_types|types=s' => \$block_types,
        'hide|hide_blocks|hidden=s'  => \$hide_types,
        'nether'                     => \$is_nether,
);
my @block_types = split(',',$block_types) if defined $block_types;
my @hide_types = split(',',$hide_types) if defined $hide_types;
my %hide_types = map {$_ => 1} @hide_types;
$hide_types{20} = 1;

if ($help) {
    print <<EOF;
Usage: perl gen_map.pl --path=/path/to/world/region/ --file=map.png --min_x=0 --min_z=0 --max_x=1 -- max_z=1

        Options:
            --path     - path to the directory that holds the region files for your world
            --file     - output image file
            --min_x/z  - smallest x and z chunk coordinates to map
            --max_x/z  - largest x and z chunk coordinates

EOF
    exit;
}
die "Must specify directory of region files" unless $full_path && -d $full_path;

my $COLORS = [
    0, # air
    '#CCC', # stone
    '#0A0', # grass
    '#993', # dirt
    '#AAA', # cobblestone
    '#BB7', # Wood
    '#590', # sapling
    '#000', # bedrock
    '#00F', # water
    '#00f', # water
    '#f00', # lava 10
    '#f00', # lava
    '#CC9', # sand
    '#BBB', # gravel
    '#FF6', # gold ore
    '#CCC', # iron ore
    '#777', # coal ore
    '#AA6', # Log
    '#380', # Leaves
    '#AA2', # sponge
    '#FFF', # glass 20
    '#F00', # red cloth
    '#F70', # orange
    '#FF0', # yellow
    '#7F0', # lime
    '#0F0', # green 
    '#0F7', # aqua green
    '#07F', # cyan
    '#00F', # blue
    '#70F', # purple
    '#707', # indigo 30
    '#F07', # violet
    '#C33', # magenta
    '#F99', # pink
    '#000', # black
    '#AAA', # gray
    '#FFF', # white
    '#FF0', # yellow flower
    '#F00', # red rose
    '#993', # brown mushroom
    '#C33', # red mushroom 40
    '#FF0', # gold block
    '#DDD', # iron block
    '#AAA', # double step
    '#AAA', # step
    '#990', # brick
    '#990', # tnt
    '#A33', # bookcase
    '#9F9', # mossy cobblestone
    '#555', # obsidian
    '#F30', # torch 50
    '#F30', # fire
    '#FFF', # mobspawner
    '#996', # wooden stairs
    '#996', # chest
    '#F00', # redstone wire
    '#DDF', # diamond ore
    '#DDF', # diamond block
    '#A33', # workbench
    '#D93', # crops
    '#A93', # soil 60
    '#999', # furnace
    '#999', # burning furnace
    '#D93', # sign post
    '#AA3', # wooden door
    '#AA3', # ladder
    '#999', # minecart tracks
    '#AAA', # cobblestone stairs
    '#AA3', #  wall sign
    '#AAA', # lever
    '#999', # stone pressure plate 70
    '#999', # iron door
    '#AA3', # wood pressure plate
    '#D00', # redstone ore
    '#E00', # glowing  redstone ore
    '#E00', # redstone torch off
    '#F00', # redstone torch on
    '#DDD', # stone button
    '#FFF', # snow
    '#AAF', # ice
    '#FFF', # snow block 80
    '#3A3', # cactus
    '#990', # clay
    '#7B0', # reed
    '#999', # jukebox
    '#AA3', # fence
];

my $terrain_data = [];
my $loaded_regions = {}; # cache regions

my $z_size = 16*($max_z - $min_z + 1);
my $x_size = 16*($max_x - $min_x + 1);

# start witha blank white image for color and a blank height image
my $image = Image::Magick->new(size => $x_size . 'x' . $z_size);
$image->ReadImage('xc:white');
my $height_image = Image::Magick->new(size => $x_size . 'x' . $z_size);
$height_image->ReadImage('xc:white');
my $type_image;
if (@block_types) {
    $type_image = Image::Magick->new(size => $x_size . 'x' . $z_size);
    $type_image->ReadImage('xc:transparent');
}

for my $chunk_z ($min_z..$max_z) {
    for my $chunk_x ($min_x .. $max_x) {
        print "Chunk $chunk_x, $chunk_z\n";
        my ($region_x, $region_z) = Minecraft::Util::get_chunk_region({chunk_x => $chunk_x, chunk_z => $chunk_z});
        my $region = $loaded_regions->{$region_x . '_' . $region_z};
        if (!$region) {
            warn "LOADING REGION: $region_x, $region_z";
            $region = Minecraft::Map::Region->new({
                    path => $full_path,
                    region_x => $region_x,
                    region_z => $region_z,
                    });
            die "Could not load region $region_x,$region_z" unless $region;
            $loaded_regions->{$region_x . '_' . $region_z} = $region;
        }
        my $chunk = $region->get_chunk({absolute_x => $chunk_x, absolute_z => $chunk_z});
        if (!$chunk) {
            print "CHUNK $chunk_x, $chunk_z missing\n";
        }

        my $data = $chunk->blocks if $chunk;

        my $x_offset = ($chunk_x - $min_x)*16;
        my $z_offset = ($chunk_z -$min_z)*16;

        for my $z (0..15) {
            my $z_index = $chunk_z*16 + $z;
            for $x (0..15) {
                my $x_index = $chunk_x*16 + $x;

                my $lowest_type = 7;

                my $img_x = $x + $x_offset;
                my $img_z = $z + $z_offset;

                my $height = $chunk->get_block_height($x,$z) if $chunk;
                my $found_block;

                for my $y (0..127) {
                    my $i = $y + ($z*128 + ($x*128*16)); 
                    my $block = $chunk->get_block_type($x,$y,$z) if $chunk;
                    if (@block_types) {
                        if (grep(/^$block$/, @block_types)) {
                            my $color = $block && ($block <= $#$COLORS) ? $COLORS->[$block] : '#000';
                            $type_image->Set("pixel[$img_x,$img_z]" => $color);
                            $height_image->SetPixel(x=>$img_x, y=>$img_z, color => [$y/128, $y/128, $y/128]);
                            $found_block++;
                        }
                    }
                    next if !$block || $hide_types{$block};
                    $lowest_type = $block if defined $block;
                }

#                $terrain_data->[$z + $z_offset]->[$x + $x_offset] = {type => $lowest_type, h => $height || '20'};

                my $color = $lowest_type && ($lowest_type <= $#$COLORS) ? $COLORS->[$lowest_type] : '#000';
                $image->Set("pixel[$img_x,$img_z]" => $color);

                $height_image->SetPixel(x=>$img_x, y=>$img_z, color => [$height/128, $height/128, $height/128]) unless $found_block;
            }
        }
    }
}

$image->Composite(image => $height_image, compose => 'Multiply');
if ($type_image) {
    $image->Modulate(brightness => 50);
    $image->Composite(image => $type_image, compose => 'Over');
}
$image->Write($outfile);

my $time_taken = time() - $time;
print "Finished in $time_taken seconds\n";
