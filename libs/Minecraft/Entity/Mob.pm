package Minecraft::Entity::Mob;

use Mouse;
extends 'Minecraft::Entity';

has 'attack_time' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'death_time' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'health' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'hurt_time' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'saddle' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Byte',
);

has 'sheared' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Byte',
);

has 'size' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Int',
);

1;
