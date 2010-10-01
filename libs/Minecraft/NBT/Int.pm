package Minecraft::NBT::Int;

use Moose;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Num',
);

has '+tag_type' => (
    default => 3,
);

1;
