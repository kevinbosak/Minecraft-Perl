package Minecraft::NBT::Float;

use Moose;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Num',
);

has '+tag_type' => (
    default => 5,
);

1;
