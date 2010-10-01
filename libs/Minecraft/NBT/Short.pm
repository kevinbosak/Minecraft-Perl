package Minecraft::NBT::Short;

use Moose;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Num',
);

has '+tag_type' => (
    default => 2,
);

1;
