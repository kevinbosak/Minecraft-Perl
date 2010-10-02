package Minecraft::NBT::Long;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Num',
);

has '+tag_type' => (
    default => 4,
);

1;
