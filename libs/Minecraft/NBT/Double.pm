package Minecraft::NBT::Double;

use Moose;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Num',
);

has '+tag_type' => (
    default => 6,
);

1;
