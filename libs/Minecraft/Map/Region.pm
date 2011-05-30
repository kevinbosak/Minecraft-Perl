package Minecraft::Map::Region;

use Mouse;

use Minecraft::NBT;
use Minecraft::Map::Chunk;
use Compress::Zlib;

has 'full_path' => (
    is => 'rw',
    isa => 'Str',
    default => sub {
        my $self = shift;
        my $x = $self->region_x;
        my $z = $self->region_z;
        my $path = $self->path;
        $path .= '/' unless substr($path,-1,1) eq '/';
        $path . join('.', 'r', $x, $z, 'mcr');
    },
    lazy => 1,
);
has 'path' => (
    is => 'rw',
    isa => 'Str',
);
#has 'raw_data' => (
#    is => 'rw',
#    isa => 'Str',
#    trigger =>  sub {
#        my ($self, $data) = @_;
#        $self->parse_raw_data($data);
#    },
#);

has 'region_x' => (
    is => 'rw',
    isa => 'Int',
);

has 'region_z' => (
    is => 'rw',
    isa => 'Int',
);

has 'chunk_locations' => (
    is => 'ro', # write through 'set_chunk'
    isa => 'HashRef',
);

has 'chunk_timestamps' => (
    is => 'rw',
    isa => 'HashRef',
);

has 'chunks' => (
    is => 'rw',
    isa => 'HashRef',
    default => sub { {} },
);

sub set_chunk {
    my ($self, $args) = @_;
    die "Need x and z params" unless defined $args->{x} && defined $args->{z};
    die "Need chunk data" unless defined $args->{data} && ref $args->{data} eq 'Minecraft::Map::Chunk';

    # FIXME:
    # check for existing values in timestamps and locations
    # create timestamp if necessary
    # find next open location
    # update location attr
    # update chunks attr

    return 1;
}

# getting these as-needed, don't parse the whole file
# FIXME: cache chunks by storing in chunks attribute  
sub get_chunk {
    my ($self, $args) = @_;

    my $x = $args->{relative_x};
    my $z = $args->{relative_z};

    if (!defined $args->{relative_x} && !defined $args->{relative_z}
        && defined $args->{absolute_x} && defined $args->{absolute_z}) {

        $x = $args->{absolute_x} % 32;
        $z = $args->{absolute_z} % 32;
    }

    die "You must specify valid coordinates" unless defined $x && defined $z;

    my $chunk;
    {
        my $FH;
        open ($FH, "<", $self->full_path) or die "Could not open " . $self->full_path;
        binmode $FH;

        my $seek_loc = 4*(($x%32)+($z%32)*32);
        my $location_data;
        seek($FH, $seek_loc, 0);
        read($FH, $location_data, 4) or die "FOO";

        my $bit_string = '0b0' . unpack('B*', substr($location_data, 0, 3, ''));
        my $data_offset;
        eval "\$data_offset = $bit_string";
        my $length = unpack('W', substr($location_data, 0, 1, ''));

        return if $length == 0 && $data_offset == 0;

        my $timestamp_data;
        seek($FH, $seek_loc+4096, 0);
        read($FH, $timestamp_data, 4) or die "FOO";

        my $timestamp = unpack('l>', $timestamp_data);

        my $chunk_data;
        seek($FH, $data_offset*4096, 0);
        read($FH, $chunk_data, $length*4096) or die "FOO";

        my $foo = substr($chunk_data, 0, 4);
        my $chunk_length = unpack('l>', substr($chunk_data, 0, 4, ''));
        my $compression_type = unpack('W', substr($chunk_data, 0, 1, ''));
        my $compressed_data = substr($chunk_data, 0, $chunk_length);

        my $decompressed_data;

        if ($compression_type == 2) {
            $decompressed_data = uncompress($chunk_data);
        } else {
            die "Unsupported compression type: $compression_type";
        }
        die "Error decompressing data" unless defined $decompressed_data;

        # decompress
        my $nbt_data = Minecraft::NBT->parse_data({data => \$decompressed_data, is_named => 1});
        $chunk = Minecraft::Map::Chunk->new({chunk_nbt_data => $nbt_data});

        close $FH;
    }
    return $chunk;

#    my $chunks = $self->chunks;

#    warn "Getting chunk $x, $z";
#    return $chunks->{$x . '_' . $z};
}

sub parse_raw_data {
    my ($self, $raw_data) = @_;
    my $location_data = substr($raw_data, 0, 4096, '');
    my $timestamp_data = substr($raw_data, 0, 4096, '');

    my $x_offset = 0;
    my $z_offset = 0;

    my $chunks = $self->chunks;

    for my $i (0..1023) {
        # TODO: cleaner way of doing this with pack?
        my $bit_string = '0b0' . unpack('B*', substr($location_data, 0, 3, ''));
        my $data_offset;
        eval "\$data_offset = $bit_string";

        my $length = unpack('W', substr($location_data, 0, 1, ''));
        my $timestamp = unpack('l>', substr($timestamp_data, 0, 4, ''));

        next unless $data_offset && $length; # empty chunks have zero for both of these

        $data_offset -= 2; # offset is now for remainder of raw data, not original raw data
        $length *= 4096;  # stored length was 4k sectors, now it's in bytes
        $data_offset *= 4096;

        my $chunk_data = substr($raw_data, $data_offset, $length);
        my $chunk_length = unpack('l>', substr($chunk_data, 0, 4, ''));
        my $compression_type = unpack('W', substr($chunk_data, 0, 1, ''));
        my $compressed_data = substr($chunk_data, 0, $length);

        my $decompressed_data;

        if ($compression_type == 2) {
            $decompressed_data = uncompress($chunk_data);
        } else {
            die "Unsupported compression type: $compression_type";
        }
        die "Error decompressing data" unless defined $decompressed_data;

        # decompress
        my $nbt_data = Minecraft::NBT->parse_data({data => \$decompressed_data, is_named => 1});
        my $chunk = Minecraft::Map::Chunk->new({chunk_nbt_data => $nbt_data});
        $chunks->{$x_offset . '_' . $z_offset} = $chunk;

        $x_offset++;
        if ($x_offset == 32) {
            $x_offset = 0;
            $z_offset++;
        }
    }
}

1;
