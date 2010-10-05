package Minecraft::Entity::Mob::Player;

use Mouse;
extends 'Minecraft::Entity::Mob';

has 'inventory' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Compound',
);

has 'score' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Int',
);


1;
