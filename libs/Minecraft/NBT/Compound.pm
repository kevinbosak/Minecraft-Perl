package Minecraft::NBT::Compound;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Maybe[ArrayRef]',
);

has '+tag_type' => (
    default => 10,
);

sub get_child_by_name {
    my ($self, $name) = @_;
    return unless $name;

    my $children = $self->payload || [];
    for my $child (@$children) {
        if ($child->name && $child->name eq $name) {
            return $child;
        }
    }
}

1;
