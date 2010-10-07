package Minecraft::Map::Util;

use Minecraft::Map;
use Minecraft::Util;

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
    my $nbt = Minecraft::NBT::parse_from_file({file => $full_path, is_named => 1});
    my $level = $nbt->payload->[0];
    return Minecraft::Map::Chunk->new({chunk_nbt_data => $level});
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

# parses the 'world' folder of a map
sub parse_map_folder {
    my $args = shift;
    $args = shift if ! ref $args;

    die "No args given" unless $args && ref $args;

    my $path = $args->{path};
    die "No valid path given" unless $path && -d $path;

    chop $path if substr($path, -1, 1) eq '/';

    require Minecraft::NBT;

    my $level_data = Minecraft::NBT->parse_from_file({file => "$path/level.dat", is_named => 1})->payload->[0];
    # TODO get players from nbt and put into Map objectx
    my $map = Minecraft::Map->new({level_nbt_data => $level_data, path => $path});

    return $map;
}

1;
