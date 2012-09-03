package Minecraft::Util;

use Readonly;
use POSIX;

Readonly my $ALL_ITEMS => {
    0   => 'air',
    1   => 'stone',
    2   => 'grass',
    3   => 'dirt',
    4   => 'cobblestone',
    5   => 'planks',
    6   => 'sapling',
    7   => 'bedrock',
    8   => 'water',
    9   => 'stationary water',
    10  => 'lava',
    11  => 'stationary lava',
    12  => 'sand',
    13  => 'gravel',
    14  => 'gold ore',
    15  => 'iron ore',
    16  => 'coal ore',
    17  => 'wood',
    18  => 'leaves',
    19  => 'sponge',
    20  => 'glass',
    21 => 'lapis lazuli ore',
    22 => 'lapis lazuli block',
    23 => 'dispenser',
    24 => 'sandstone',
    25 => 'note block',
    26 => 'bed',
    27 => 'powered rail',
    28 => 'detector rail',
    29 => 'sticky piston',
    30 => 'cobweb',
    31 => 'tall grass',
    32 => 'dead bush',
    33 => 'piston',
	34 => 'piston extension',
    35 => 'wool',
	36 => 'block moved by piston',
    37  => 'yellow flower',
    38  => 'red flower',
    39  => 'brown mushroom',
    40  => 'red mushroom',
    41  => 'gold block',
    42  => 'iron block',
    43  => 'double slab',
    44  => 'slab',
    45  => 'brick',
    46  => 'TNT',
    47  => 'bookshelf',
    48  => 'mossy cobblestone',
    49  => 'obsidian',
    50  => 'torch',
    51  => 'fire', # hide
    52  => 'mob spawner',
    53  => 'wooden stairs',
    54  => 'chest',
    55  => 'redstone wire', # hide
    56  => 'diamond ore',
    57  => 'diamond block',
    58  => 'workbench',
    59  => 'crops', # hide
    60  => 'soil', # hide
    61  => 'furnace',
    62  => 'burning furnace', # hide
    63  => 'sign post',
    64  => 'wooden door',
    65  => 'ladder',
    66  => 'rails',
    67  => 'cobblestone stairs',
    68  => 'wall sign', # hide
    69  => 'lever',
    70  => 'stone pressure plate',
    71  => 'iron door',
    72  => 'wooden pressure plate',
    73  => 'redstone ore',
    74  => 'glowing redstone ore', # hide
    75  => 'redstone torch (off)',
    76  => 'redstone torch (on)', # hide
    77  => 'stone button',
    78  => 'snow',
    79  => 'ice',
    80  => 'snow block',
    81  => 'cactus',
    82  => 'clay', # hide
    83  => 'reed', # hide
    84  => 'jukebox',
    85  => 'fence',
    86 => 'pumpkin',
    87 => 'netherrack',
    88 => 'soul sand',
    89 => 'glowstone',
    90 => 'portal',
    91 => 'jack-o-lantern',
    92 => 'cake block',
    93 => 'redstone repeater',
    94 => 'redstone repeater',
	95 => 'locked chest',
    96 => 'trapdoor',
	97 => 'monster egg',
	98 => 'stone bricks',
	99 => 'huge brown mushroom',
	100 => 'huge red mushroom',
	101 => 'iron bars',
	102 => 'glass pane',
	103 => 'melon',
	104 => 'pumpkin stem',
	105 => 'melon stem',
	106 => 'vines',
	107 => 'fence gate',
	108 => 'brick stairs',
	109 => 'stone brick stairs',
	110 => 'mycelium',
	111 => 'lily pad',
	112 => 'nether brick',
	113 => 'nether brick fence',
	114 => 'nether brick stairs',
	115 => 'nether wart',
	116 => 'enchantment table',
	117 => 'brewing stand',
	118 => 'cauldron',
	119 => 'end portal',
	120 => 'end portal frame',
	121 => 'end stone',
	122 => 'dragon egg',
	123 => 'active redstone lamp',
	124 => 'inactive redstone lamp',
	125 => 'wooden double slab',
	126 => 'wooden slab',
	127 => 'cocoa plant',
	128 => 'sandstone stairs',
	129 => 'emerald ore',
	130 => 'ender chest',
	131 => 'tripwire hook',
	132 => 'tripwire',
	133 => 'emerald block',
	134 => 'spruce stairs',
	135 => 'birch stairs',
	136 => 'jungle wood stairs',
	137 => 'command block',
	138 => 'beacon block',
	139 => 'cobblestone wall',
	140 => 'flower pot',
	141 => 'carrots',
	142 => 'potatoes',
	143 => 'wooden button',

    256 => 'iron spade',
    257 => 'iron pickaxe',
    258 => 'iron axe',
    259 => 'flint and steel',
    260 => 'apple',
    261 => 'bow',
    262 => 'arrow',
    263 => 'coal',
    264 => 'diamond',
    265 => 'iron ingot',
    266 => 'gold ingot',
    267 => 'iron sword',
    268 => 'wooden sword',
    269 => 'wooden spade',
    270 => 'wooden pickaxe',
    271 => 'wooden axe',
    272 => 'stone sword',
    273 => 'stone spade',
    274 => 'stone pickaxe',
    275 => 'stone axe',
    276 => 'diamond sword',
    277 => 'diamond spade',
    278 => 'diamond pickaxe',
    279 => 'diamond axe',
    280 => 'stick',
    281 => 'bowl',
    282 => 'mushroom soup',
    283 => 'gold sword',
    284 => 'gold spade',
    285 => 'gold pickaxe',
    286 => 'gold axe',
    287 => 'string',
    288 => 'feather',
    289 => 'gunpowder',
    290 => 'wooden hoe',
    291 => 'stone hoe',
    292 => 'iron hoe',
    293 => 'diamond hoe',
    294 => 'gold hoe',
    295 => 'seeds',
    296 => 'wheat',
    297 => 'bread',
    298 => 'leather helmet',
    299 => 'leather chestplate',
    300 => 'leather pants',
    301 => 'leather boots',
    302 => 'chainmail helmet',
    303 => 'chainmail chestplate',
    304 => 'chainmail pants',
    305 => 'chainmail boots',
    306 => 'iron helmet',
    307 => 'iron chestplate',
    308 => 'iron pants',
    309 => 'iron boots',
    310 => 'diamond helmet',
    311 => 'diamond chestplate',
    312 => 'diamond pants',
    313 => 'diamond boots',
    314 => 'gold helmet',
    315 => 'gold chestplate',
    316 => 'gold pants',
    317 => 'gold boots',
    318 => 'flint',
    319 => 'pork',
    320 => 'grilled pork',
    321 => 'paintings',
    322 => 'golden apple',
    323 => 'sign',
    324 => 'wooden door',
    325 => 'bucket',
    326 => 'water bucket',
    327 => 'lava bucket',
    328 => 'mine cart',
    329 => 'saddle',
    330 => 'iron door',
    331 => 'redstone',
    332 => 'snowball',
    333 => 'boat',
    334 => 'leather',
    335 => 'milk bucket',
    336 => 'clay brick',
    337 => 'clay balls',
    338 => 'reed',
    339 => 'paper',
    340 => 'book',
    341 => 'slime ball',
    342 => 'storage minecart',
    343 => 'powered minecart',
    344 => 'egg',
    345 => 'compass',
    346 => 'fishing rod',
    347 => 'watch',
    348 => 'lightstone dust',
    349 => 'fish',
    350 => 'cooked fish',
    351 => 'dye',
    352 => 'bone',
    353 => 'sugar',
    354 => 'cake',
	355 => 'bed',
	356 => 'repeater',
	357 => 'cookie',
    358 => 'map',
    359 => 'shears',
	360 => 'melon slice',
	361 => 'pumpkin seeds',
	362 => 'melon seeds',
	363 => 'raw beef',
	364 => 'steak',
	365 => 'raw chicken',
	366 => 'cooked chicken',
	367 => 'rotten flesh',
	368 => 'ender pearl',
	369 => 'blaze rod',
	370 => 'ghast tear',
	371 => 'gold nugget',
	372 => 'nether wart',
	373 => 'potions',
	374 => 'glass bottle',
	375 => 'spider eye',
	376 => 'fermented spider eye',
	377 => 'blaze powder',
	378 => 'magma cream',
	379 => 'brewing stand',
	380 => 'cauldron',
	381 => 'eye of ender',
	382 => 'glistering melon',
	383 => 'spawn egg',
	384 => 'bottle of enchanting',
	385 => 'fire charge',
	386 => 'book and quill',
	387 => 'written book',
	388 => 'emerald',
	389 => 'item frame',
	390 => 'flower pot',
	391 => 'carrots',
	392 => 'potato',
	393 => 'baked potato',
	394 => 'poisonous potato',
	395 => 'map',
	396 => 'golden carrot',
	2256 => '13 disc',
    2257 => 'cat disc',
	2258 => 'blocks disc',
	2259 => 'chirp disc',
	2260 => 'far disc',
	2261 => 'mall disc',
	2262 => 'mellohi disc',
	2263 => 'stal disc',
	2264 => 'strad disc',
	2265 => 'ward disc',
	2266 => '11 disc',
};

Readonly my $INVENTORY_ITEMS => [qw(
    1   
    2   
    3   
    4   
    5   
    6   
    7   
    9   
    11  
    12  
    13  
    14  
    15  
    16  
    17  
    18  
    19  
    20  
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
	34
    35
	36	
    37  
    38  
    39  
    40  
    41  
    42  
    44  
    45  
    46  
    47  
    48  
    49  
    50  
    52
    53  
    54  
    56  
    57  
    58  
    61  
    65  
    66  
    67  
    69  
    70  
    72  
    73  
    75  
    77  
    78
    79
    80
    81  
    82
    84  
    85  
    86
    87
    88
    89
    90
    91
    92
    93
	94
	95
    96

    256 
    257 
    258 
    259 
    260 
    261 
    262 
    263 
    264 
    265 
    266 
    267 
    268 
    269 
    270 
    271 
    272 
    273 
    274 
    275 
    276 
    277 
    278 
    279 
    280 
    281 
    282 
    283 
    284 
    285 
    286 
    287 
    288 
    289 
    290 
    291 
    292 
    293 
    294 
    295 
    296 
    297 
    298 
    299 
    300 
    301 
    302 
    303 
    304 
    305 
    306 
    307 
    308 
    309 
    310 
    311 
    312 
    313 
    314 
    315 
    316 
    317 
    318 
    319 
    320 
    321 
    322 
    323 
    324 
    325 
    326 
    327 
    328 
    329 
    330 
    331 
    332 
    333 
    334 
    335 
    336 
    337 
    338 
    339 
    340 
    341 
    342 
    343 
    344 
    345 
    346 
    347
    348
    349
    350
    358
    351
    352
    353
    354
    358
    359
    2256
    2257
)];

# NOTE: This may change to include description of each item value
Readonly my $SPECIAL_ITEMS => {
    6  => [0..2],
    17 => [0..2],
    18 => [0..2],
    43 => [0..3],
    44 => [0..3],
    31 => [0..2],
    35 => [0..15],
    351 => [0..15],
};

Readonly my $GRASS_TYPES => [
    'dead shrub',
    'tall grass',
    'fern',
];

Readonly my $SLAB_TYPES => [
    'stone',
    'sandstone',
    'wood',
    'cobblestone',
];

Readonly my $WOOL_COLORS => [
    'white',
    'orange',
    'magenta',
    'light blue',
    'yellow',
    'light green',
    'pink',
    'dark gray',
    'gray',
    'cyan',
    'purple',
    'blue',
    'brown',
    'dark green',
    'red',
    'black',
];

Readonly my $TREE_TYPES => [
    'normal',
    'redwood',
    'birch',
];

Readonly my $DYES => [
    'ink sack',
    'rose red',
    'cactus green',
    'coco beans',
    'lapis lazuli',
    'purple dye',
    'cyan dye',
    'light gray dye',
    'gray dye',
    'pink dye',
    'lime dye',
    'dandelion yellow',
    'light blue dye',
    'magenta dye',
    'orange dye',
    'bone meal',
];

Readonly my $PROFESSIONS => [
	'Farmer',
	'Librarian',
	'Priest',
	'Blacksmith',
	'Butcher',
	'Villager',
];

# FIXME: need some way to denote damage is used for wool color

sub item_has_damage {
    my $item_id = shift;
    $item_id = shift if $item_id eq __PACKAGE__;

    return unless $item_id && $item_id =~ m/^\d+$/;
    if (($item_id >= 256 && $item_id <=259) || ($item_id >= 267 && $item_id <= 279)
                || ($item_id >= 283 && $item_id <= 286) || ($item_id >= 298 && $item_id <= 317
                || $item_id == 358)) {
        return 1;
    }
}

sub get_items {
    return wantarray ? %$ALL_ITEMS : $ALL_ITEMS;
}

sub get_special_items {
    return wantarray ? %$SPECIAL_ITEMS : $SPECIAL_ITEMS;
}

sub get_inventory_items {
    my %items = ();
    for my $id (@$INVENTORY_ITEMS) {
        $items{$id} = $ALL_ITEMS->{$id};
    }
    return wantarray ? %items : \%items;
}

sub get_item_name {
    my $id = shift;
    if ($id eq __PACKAGE__) {
        $id = shift;
    }
	my $return = $ALL_ITEMS->{$id};
	if(!$return){$return="<unknown($id)>";}
    return $return;
}

sub get_profession {
    my $id = shift;
    if ($id eq __PACKAGE__) {
        $id = shift;
    }
	my $return = $PROFESSIONS->[$id];
	if(!$return){$return="<unknown profession($id)>";}
    return $return;
}

sub get_item_id {
    my $name = shift;
    if ($name eq __PACKAGE__) {
        $name = shift;
    }
    my %items = reverse %$ALL_ITEMS;
    return $items{$name};
}

sub get_special_item_name {
    my $id = shift;
    if ($id eq __PACKAGE__) {
        $id = shift;
    }
    my $special_val = shift;

    if ($id == 35) {
        return $WOOL_COLORS->[$special_val];
    } elsif ($id == 31) {
        return $GRASS_TYPES->[$special_val];
    } elsif ($id == 43) {
        return $SLAB_TYPES->[$special_val];
    } elsif ($id == 44) {
        return $SLAB_TYPES->[$special_val];
    } elsif ($id == 17 || $id == 6 || $id == 18) {
        return $TREE_TYPES->[$special_val];
    } elsif ($id == 351) {
        return $DYES->[$special_val];
    }
}

sub get_wool_colors {
    return wantarray ? @$WOOL_COLORS : $WOOL_COLORS;
}

sub get_dyes {
    return wantarray ? @$DYES : $DYES;
}

sub get_region_filename {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }

    my $x = $args->{region_x};
    my $z = $args->{region_z};
    
    return unless defined $x && defined $z;

    return join('.', 'r', $x, $z, 'mcr');
}

sub get_chunk_region {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }

    my $x_pos = $args->{chunk_x};
    my $z_pos = $args->{chunk_z};

    die "Must give x and z positions" unless (defined $x_pos && defined $z_pos);

    my $x = int(floor($x_pos / 32));
    my $z = int(floor($z_pos / 32));

    return wantarray ? ($x,$z) : [$x,$z];
}

sub get_write_fh {
    my $filename = shift;

    $filename = shift if $filename eq __PACKAGE__;
    die "No file given" unless $filename;

    require PerlIO::gzip;

    my $FH;
    open $FH, ">:gzip", $filename or die $!;
    return $FH;
}

# FIXME: NOT USED. Take out if this isn't needed. Regions now load chunks on they fly
sub load_region_from_file {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }

    require Minecraft::Map::Region;

    my $full_path = $args->{full_path};

    my $path = $args->{path};
    my $region_x = $args->{region_x};
    my $region_z = $args->{region_z};

    if (!$full_path && defined $region_x && defined $region_z) {
        $path ||= '.';
        $path .= '/' unless $path =~ /\/$/;

        my $filename = get_region_filename({region_x => $region_x, region_z => $region_z});
        $full_path = $path . $filename;
    }

    warn "$full_path";
    die "Invalid file specified" unless defined $full_path && -e $full_path;

    my $data;
    {
        open my $fh, '<', $full_path or die "Could not open $full_path";
        local $/;
        $data = <$fh>; 
        close $fh;
    }
    return Minecraft::Map::Region->new({raw_data => $data, region_x => $region_x, region_z => $region_z});
}

1;

=head1 NAME

Minecraft::Util - Helper functions for common minecraft-related commands.

=head1 VERSION

This documentation refers to Minecraft::Util version $Revision$

=head1 SYNOPSIS

    use Minecraft::Util;

    my $world_path = '/some/path/to/world';
    my ($region_x, $region_z) = Minecraft::Util::get_chunk_region({chunk_x => 1234, chunk_z => 567});
    my $region_filename = Minecraft::Util::get_region_filename({region_x => $region_x, region_z => $region_z});
    my $full_region_path = $world_path . $region_filename;

=head1 DESCRIPTION

This module provides various utility functions for Minecraft-related data.  
Currently it only opens and auto-(un)gzips files.  This is done using 
PerlIO::gzip which cannot open a read/write filehandle.

=head1 FUNCTIONS

=head2 get_chunk_region(args)

Takes params 'chunk_x' and 'chunk_z' and returns the an array or arrayref containing the x and z 
coordinates of the region the chunk is in.

=head2 get_region_filename(args)

Takes params 'region_x' and 'region_z' and returns the filename for the region (ie. r.0.0.mcr).

=head2 load_region_from_file(args)

NOT SUPPORTED currently. Regions now know their filename and load chunks on the fly.  Much faster this way.

Takes either 'full_path' or 'path', 'region_x', and 'region_z' and returns the appropriate 
Minecraft::Map::Region object.

=head1 AUTHOR

Kevin Bosak
