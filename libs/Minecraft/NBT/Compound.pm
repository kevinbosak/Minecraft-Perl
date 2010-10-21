package Minecraft::NBT::Compound;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Maybe[HashRef]',
);

has '+tag_type' => (
    default => 10,
);

sub remove_child_by_name {
    my ($self, $name) = @_;
    return unless $name;

    my $children = $self->payload || {};
    delete $children->{$name} if defined $children->{$name};
}

sub get_child_by_name {
    my ($self, $name) = @_;
    return unless $name;

    my $children = $self->payload || {};
    return $children->{$name};
}

1;
