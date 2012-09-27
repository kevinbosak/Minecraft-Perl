package Minecraft::InventoryItem;

use Mouse;

has 'nbt_data' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Compound',
);

has 'id' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $id =$data->get_child_by_name('id');
                return $id->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('id')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'damage' => (
    is => 'rw',
    isa => 'Maybe[Int]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $damage =$data->get_child_by_name('Damage');
                return $damage->payload if $damage;
            }
        },
    trigger => sub {
            # FIXME: create NBT item if it doesn't already exist
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Damage')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'count' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                return $data->get_child_by_name('Count')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Count')->payload($new_val);
            }
        },
);

has 'slot' => (
    is => 'rw',
    isa => 'Maybe[Int]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
				my $slot = $data->get_child_by_name('Slot');
                return $slot->payload if $slot;
            }
			return undef;
        },
    trigger => sub {
            # FIXME: create NBT item if it doesn't already exist
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Slot')->payload($new_val);
            }
        },
);

#TODO Remove this? Why is this needed?
around BUILDARGS => sub {
    my ($orig, $class, $args) = @_;

    if (!$args->{nbt_data}) {
        require Minecraft::NBT::Compound;
        require Minecraft::NBT::Short;
        require Minecraft::NBT::Byte;

        my $id = Minecraft::NBT::Short->new({name => 'id', payload => $args->{id}});

        my $nbt_data = Minecraft::NBT::Compound->new(payload => [$id]);

        my $damage = Minecraft::NBT::Short->new({name => 'Damage', payload => $args->{damage} || 0});
        $nbt_data->add_child($damage);

        my $count = Minecraft::NBT::Byte->new({name => 'Count', payload => $args->{count}});
        $nbt_data->add_child($count);

        if (defined $args->{slot}) {
            my $slot = Minecraft::NBT::Byte->new({name => 'Slot', payload => $args->{slot}});
            $nbt_data->add_child($slot);
        }
        $args->{nbt_data} = $nbt_data;
    }
    return $class->$orig($args);
};

sub as_perl {
    my $self = shift;

    my $return = {};
    $return->{id} = $self->id;
    $return->{slot} = $self->slot;
    $return->{count} = $self->count;
    $return->{damage} = $self->damage;
    return $return;
}

1;
