package Minecraft::NBT::ByteArray;

use Moose;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Maybe[ArrayRef]',
);

has '+tag_type' => (
    default => 7,
);

1;
