package Minecraft::Entity;

use Mouse;

has 'id' => (
    is => 'rw',
    isa => 'Minecraft::NBT::String',
);

has 'pos' => (
    is => 'rw',
    isa => 'Minecraft::NBT::List',
);

has 'motion' => (
    is => 'rw',
    isa => 'Minecraft::NBT::List',
);

has 'rotation' => (
    is => 'rw',
    isa => 'Minecraft::NBT::List',
);

has 'fall_distance' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Float',
);

has 'fire' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'air' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'on_ground' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Byte',
);

1;
