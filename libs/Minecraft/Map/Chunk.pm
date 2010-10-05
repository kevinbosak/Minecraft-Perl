package Minecraft::Map::Chunk;

use Mouse;

has 'blocks' => (
    is => 'rw',
    isa => 'Minecraft::NBT::ByteArray',
);

has 'data' => (
    is => 'rw',
    isa => 'Minecraft::NBT::ByteArray',
);

has 'sky_light' => (
    is => 'rw',
    isa => 'Minecraft::NBT::ByteArray',
);

has 'block_light' => (
    is => 'rw',
    isa => 'Minecraft::NBT::ByteArray',
);

has 'height_map' => (
    is => 'rw',
    isa => 'Minecraft::NBT::ByteArray',
);

has 'entities' => (
    is => 'rw',
    isa => 'ArrayRef[Minecraft::Entity]',
    default => sub { [] },
);

has 'tile_entities' => (
    is => 'rw',
    isa => 'ArrayRef[Minecraft::Entity]',
    default => sub { [] },
);

has 'last_update' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Long',
);

has 'x_pos' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Int',
);

has 'z_pos' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Int',
);

has 'terrain_populated' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Byte',
    default => 0,
);

1;
