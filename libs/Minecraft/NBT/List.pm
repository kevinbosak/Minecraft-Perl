package Minecraft::NBT::List;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa => 'Maybe[ArrayRef]',
    default => sub { return []},
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
