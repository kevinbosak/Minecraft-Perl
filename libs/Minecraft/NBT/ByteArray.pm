package Minecraft::NBT::ByteArray;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
#    isa =>  => 'Maybe[ArrayRef]',
    isa =>  => 'Maybe[Str]',
);

has '+tag_type' => (
    default => 7,
);

1;
