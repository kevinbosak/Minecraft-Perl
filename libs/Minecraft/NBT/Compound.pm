package Minecraft::NBT::Compound;

use Mouse;
extends 'Minecraft::NBT';

has '+payload' => (
    isa =>  => 'Maybe[ArrayRef]',
);

has '+tag_type' => (
    default => 10,
);

sub add_child {
    my ($self, $child) = @_;

    my $children = $self->payload || [];
    push @$children, $child;
    $self->payload($children);
}

sub remove_child_by_name {
    my ($self, $name) = @_;
    return unless $name;

    my $children = $self->payload || [];
    my @children = ();
    for my $child (@$children) {
        push @children, $child unless $child->name && $child->name eq $name;
    }
    $self->payload(\@children);
}

sub get_child_by_name {
    my ($self, $name) = @_;
    return unless $name;

    my $children = $self->payload || [];
    for my $child (@$children) {
        return $child if $child->name && $child->name eq $name;
    }
}

1;
