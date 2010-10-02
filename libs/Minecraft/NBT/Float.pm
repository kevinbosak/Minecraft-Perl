package Minecraft::NBT::Float;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Num',
);

has '+tag_type' => (
    default => 5,
);

1;
