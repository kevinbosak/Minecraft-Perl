package Minecraft::NBT::List;

use Moose;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Maybe[ArrayRef]',
);

has '+tag_type' => (
    default => 9,
);

has 'subtag_type' => (
    is => 'rw',
    isa => 'Int',
    default => '',
);

1;
