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
                my $block_data = $chunk_data->get_child_by_name('Blocks')->payload;
                my @blocks = vec($block_data, 0, 8);
                return \@blocks;
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
                my $block_data = $chunk_data->get_child_by_name('Data')->payload;
                my @blocks = vec($block_data, 0, 4);
                return \@blocks;
            }
        },
    lazy => 1,
);

has 'sky_light' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('SkyLight')->payload;
                my @blocks = vec($block_data, 0, 4);
                return \@blocks;
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
                my $block_data = $chunk_data->get_child_by_name('BlockLight')->payload;
                my @blocks = vec($block_data, 0, 4);
                return \@blocks;
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
                my $block_data = $chunk_data->get_child_by_name('HeightMap')->payload;
                my @blocks = vec($block_data, 0, 8);
                return \@blocks;
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
                return $chunk_data->get_child_by_name('LastUpdate')->payload;
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
                return $chunk_data->get_child_by_name('xPos')->payload;
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
                return $chunk_data->get_child_by_name('zPos')->payload;
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
                return $chunk_data->get_child_by_name('zPos')->payload;
            }
            return 0;
        },
    lazy => 1,
);

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
