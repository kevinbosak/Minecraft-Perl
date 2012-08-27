package Minecraft::TileEntity;

use Mouse;

has 'entity_nbt_data' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Compound',
);

has 'id' => (
    is => 'rw',
    isa => 'Maybe[Str]',
    default => sub {
            my $self = shift;
            if (my $data = $self->entity_nbt_data) {
                my $id = $data->get_child_by_name('id');
                return $id->payload if $id;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->chunk_nbt_data) {
	            $data->get_child_by_name('id')->payload($new_val);
            }
        },
    lazy => 1,
);
has 'x' => (
    is => 'rw',
    isa => 'Maybe[Int]',
    default => sub {
            my $self = shift;
            if (my $data = $self->entity_nbt_data) {
                my $id = $data->get_child_by_name('x');
                return $id->payload if $id;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->chunk_nbt_data) {
	            $data->get_child_by_name('x')->payload($new_val);
            }
        },
    lazy => 1,
);
has 'y' => (
    is => 'rw',
    isa => 'Maybe[Int]',
    default => sub {
            my $self = shift;
            if (my $data = $self->entity_nbt_data) {
                my $id = $data->get_child_by_name('y');
                return $id->payload if $id;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->chunk_nbt_data) {
	            $data->get_child_by_name('y')->payload($new_val);
            }
        },
    lazy => 1,
);
has 'z' => (
    is => 'rw',
    isa => 'Maybe[Int]',
    default => sub {
            my $self = shift;
            if (my $data = $self->entity_nbt_data) {
                my $id = $data->get_child_by_name('z');
                return $id->payload if $id;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->chunk_nbt_data) {
	            $data->get_child_by_name('id')->payload($new_val);
            }
        },
    lazy => 1,
);


sub as_nbt_data {
    my $self = shift;
    require Minecraft::NBT::Compound;

    my $nbt = Minecraft::NBT::Compound->new({name => '', payload => [$self->entity_nbt_data]});
    return $nbt->as_nbt;
}

1;
