package Minecraft::NBT::String;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Str',
);

has '+tag_type' => (
    default => 8,
);

1;
