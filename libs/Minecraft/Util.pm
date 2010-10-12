package Minecraft::Util;

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
