package Minecraft::NBT::Compound;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Maybe[ArrayRef]',
);

has '+tag_type' => (
    default => 10,
);

1;
