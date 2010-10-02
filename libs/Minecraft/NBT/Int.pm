package Minecraft::NBT::Int;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Num',
);

has '+tag_type' => (
    default => 3,
);

1;
