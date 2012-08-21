package Minecraft::NBT::IntArray;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
#    isa =>  => 'Maybe[ArrayRef]',
    isa =>  => 'ArrayRef[Int]',
);

has '+tag_type' => (
    default => 11,
);

1;
