package Minecraft::Util;

use Readonly;

Readonly my $ITEMS => {
    0   => 'air',
    1   => 'stone',
    2   => 'grass',
    3   => 'dirt',
    4   => 'cobblestone',
    5   => 'wood',
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
    17  => 'log',
    18  => 'leaves',
    19  => 'sponge',
    20  => 'glass',
    21  => 'red cloth',
    22  => 'orange cloth',
    23  => 'yellow cloth',
    24  => 'lime cloth',
    25  => 'green cloth',
    26  => 'aqua green cloth',
    27  => 'cyan cloth',
    28  => 'blue cloth',
    29  => 'purple cloth',
    30  => 'indigo cloth',
    31  => 'violet cloth',
    32  => 'magenta cloth',
    33  => 'pink cloth',
    34  => 'black cloth',
    35  => 'gray cloth',
    36  => 'white cloth',
    37  => 'yellow flower',
    38  => 'red flower',
    39  => 'brown mushroom',
    40  => 'red mushroom',
    41  => 'violet gold block',
    42  => 'iron block',
    43  => 'double step',
    44  => 'step',
    45  => 'brick',
    46  => 'TNT',
    47  => 'bookcase',
    48  => 'mossy cobblestone',
    49  => 'obsidian',
    50  => 'torch',
    51  => 'fire',
    52  => 'mob spawner',
    53  => 'wooden stairs',
    54  => 'chest',
    55  => 'redstone wire',
    56  => 'diamond ore',
    57  => 'diamond block',
    58  => 'workbench',
    59  => 'crops',
    60  => 'soil',
    61  => 'furnace',
    62  => 'burning furnace',
    63  => 'sign post',
    64  => 'wooden door',
    65  => 'ladder',
    66  => 'minecart tracks',
    67  => 'cobblestone stairs',
    68  => 'wall sign',
    69  => 'lever',
    70  => 'stone pressure plate',
    71  => 'iron door',
    72  => 'wooden pressure plate',
    73  => 'redstone ore',
    74  => 'glowing redstone ore',
    75  => 'redstone torch (off)',
    76  => 'redstone torch (on)',
    77  => 'stone button',
    78  => 'snow',
    79  => 'ice',
    80  => 'soil',
    81  => 'cactus',
    82  => 'clay',
    83  => 'reed',
    84  => 'jukebox',
    85  => 'fence',

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
    2256 => 'gold record',
    2257 => 'green record',
};

sub get_item_name {
    my $id = shift;
    if ($id eq __PACKAGE__) {
        $id = shift;
    }
    return $ITEMS->{$id};
}

sub get_item_id {
    my $name = shift;
    if ($name eq __PACKAGE__) {
        $name = shift;
    }
    my %items = reverse %$ITEMS;
    return $items{$name};
}

sub get_read_fh {
    my $filename = shift;

    $filename = shift if ($filename eq __PACKAGE__);
    die "No file given" unless $filename;

    require PerlIO::gzip;

    my $FH;
    open $FH, "<:gzip", $filename or die $!;
    return $FH;
}

sub get_write_fh {
    my $filename = shift;

    $filename = shift if $filename eq __PACKAGE__;
    die "No file given" unless $filename;

    require PerlIO::gzip;

    my $FH;
    open $FH, ">:gzip", $filename or die $!;
#    binmode $FH;
    return $FH;
}

sub get_chunk_path {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }

    my $x_pos = $args->{chunk_x};
    my $z_pos = $args->{chunk_z};

    die "Must give x and z positions" unless (defined $x_pos && defined $z_pos);

    my $mod_64_x = $x_pos % 64;
    my $mod_64_z = $z_pos % 64;

    my $base_mod_x = _base_36($mod_64_x);
    my $base_mod_z = _base_36($mod_64_z);

    my $base_x = _base_36($x_pos);
    my $base_z = _base_36($z_pos);

    return "$base_mod_x/$base_mod_z/c.$base_x.$base_z.dat";
}

sub _base_36 {
    my $n = shift;
    return(0) if $n == 0;

    my $negative = 0;
    if ($n < 0) {
        $n = -1 * $n;
        $negative = 1;
    }

    my $s = '';
    while ( $n ) {
        my $v = $n % 36;
        if ($v <= 9) {
            $s .= $v;
        } else {
            $s .= chr(55 + $v); # Assume that 'A' is 65
        }
            $n = int $n / 36;
    }
    my $return = reverse $s;
    $return = '-' . $return if $negative;
    return lc($return);
}

sub load_chunk_from_file {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }

    die "Need chunk position" unless defined $args->{chunk_x} && defined $args->{chunk_z};

    require Minecraft::NBT;
    require Minecraft::Map::Chunk;

    my $path = delete $args->{path} || '';
    $path =~ s/\/$// if $path;

    my $full_path = "$path/" . get_chunk_path($args);
    return unless -e $full_path;

    my $nbt = Minecraft::NBT::parse_from_file({file => $full_path, is_named => 1});
    my $level = $nbt->payload->[0];
    return Minecraft::Map::Chunk->new({chunk_nbt_data => $level});
}

1;

=head1 NAME

Minecraft::Util - Helper functions for common minecraft-related commands.

=head1 VERSION

This documentation refers to Minecraft::Util version $Revision$

=head1 SYNOPSIS

    use Minecraft::Util;

    my $FH = Minecraft::Util::get_read_fh('world/local.dat');
    my $FH = Minecraft::Util::get_write_fh('world/local.dat');

    my $world_path = '/some/path/to/world';
    my $chunk_path = Minecraft::Util::get_chunk_path({chunk_x => $x, chunk_z => $z});
    my $full_chunk_path = $world_path . $chunk_path;
    
    my $chunk_obj = Minecraft::Util::load_chunk_from_path({path => $world_path, chunk_x => $x, chunk_z => $z});

=head1 DESCRIPTION

This module provides various utility functions for Minecraft-related data.  
Currently it only opens and auto-(un)gzips files.  This is done using 
PerlIO::gzip which cannot open a read/write filehandle.

=head1 FUNCTIONS

=head2 get_read_fh(filename)

Open and return a readonly filehandle.  It is assumed the file being opened has been gzipped.

=head2 get_write_fh(filename)

Open and return a write filehandle.  The file being written will be auto-gzipped.

=head2 get_chunk_path(args)

Takes params 'chunk_x' and 'chunk_z' and returns the relative path (from root of world folder)
to the chunk file.

=head1 AUTHOR

Kevin Bosak
