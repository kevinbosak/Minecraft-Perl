package Minecraft::Entity::Item;

use Mouse;
extends 'Minecraft::Entity';

has 'health' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'age' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Short',
);

has 'item' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Compound',
);

1;
