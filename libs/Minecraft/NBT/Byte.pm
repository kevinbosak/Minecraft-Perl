package Minecraft::NBT::Byte;

use Moose;
extends 'Minecraft::NBT';

has '+tag_type' => (
    default => 1,
);

1;
