package Minecraft::Map::Chunk;

use Mouse;

use Minecraft::NBT::Compound;
use Minecraft::NBT::ByteArray;
use Minecraft::NBT::Byte;
use Minecraft::NBT::Int;
use Minecraft::NBT::Long;
use Minecraft::NBT::List;

has 'chunk_nbt_data' => (
    is => 'rw',
    isa => 'Minecraft::NBT',
);

has 'blocks' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('Blocks')->payload;
                my @blocks = unpack('C*', $block_data);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = pack('C*', @$new_val);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('Blocks')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'data' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('Data')->payload;
                my $block_string = unpack('H*', $block_data);
                my @blocks = split('', $block_string);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my @blocks = join('', @$new_val);
                my $block_data = pack('H*', @blocks);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('Data')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'sky_light' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('SkyLight')->payload;
                my $block_string = unpack('H*', $block_data);
                my @blocks = split('', $block_string);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my @blocks = join('', @$new_val);
                my $block_data = pack('H*', @blocks);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('SkyLight')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'block_light' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('BlockLight')->payload;
                my $block_string = unpack('H*', $block_data);
                my @blocks = split('', $block_string);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my @blocks = join('', @$new_val);
                my $block_data = pack('H*', @blocks);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('BlockLight')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'height_map' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
#                my $block_data = $chunk_data->get_child_by_name('HeightMap')->payload;

                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('HeightMap')->payload;
                my @blocks = unpack('C*', $block_data);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = pack('C*', @$new_val);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('HeightMap')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'entities' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has 'tile_entities' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has 'last_update' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('LastUpdate')->payload;
            }
        },
    lazy => 1,
);

has 'x_pos' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('xPos')->payload;
            }
        },
    lazy => 1,
);

has 'z_pos' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('zPos')->payload;
            }
        },
    lazy => 1,
);

has 'terrain_populated' => (
    is => 'rw',
    isa => 'Bool',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('TerrainPopulated')->payload;
            }
            return 0;
        },
    lazy => 1,
);

sub get_block_type {
    my ($self, $x, $y, $z) = @_;
    die "Must specify x, y, and z" unless defined $x && defined $z && defined $y;

    my $blocks = $self->blocks;
    return unless $blocks && scalar @$blocks;

    my $i = $y + ($z*128 + ($x*128*16));
    return $blocks->[$i];
}

sub get_block_height {
    my ($self, $x, $z) = @_;
    die "Must specify x, and z" unless defined $x && defined $z;

    my $blocks = $self->height_map;
    return unless $blocks && scalar @$blocks;

    my $i = $x + $z*16;
    return $blocks->[$i];
}

sub as_nbt_object {
    my $self = shift;

    # get entities as nbt objs
    # get tile_entities as nbt objs
    # create a wrapper object
}

sub as_nbt {
    return $_->as_nbt_object->as_nbt;
}

1;
