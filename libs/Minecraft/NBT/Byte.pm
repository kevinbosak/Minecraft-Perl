package Minecraft::NBT::Byte;

use Mouse;
extends 'Minecraft::NBT';

has '+tag_type' => (
    default => 1,
);

1;
