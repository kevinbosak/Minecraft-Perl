package Minecraft::TileEntity::Furnace;

use Mouse;
extends 'Minecraft::TileEntity';

has 'burn_time' => (
    is => 'rw',
    isa => 'Num',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var =$data->get_child_by_name('BurnTime');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('BurnTime')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'cook_time' => (
    is => 'rw',
    isa => 'Num',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var =$data->get_child_by_name('CookTime');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('CookTime')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'input' => (
    is => 'rw',
    isa => 'Maybe[Minecraft::InventoryItem]',
    default => sub {
			my $self = shift;
            return $self->_get_slot_item(0);
        },
    # trigger => sub {
            # my ($self, $new_val, $old_val) = @_;
            # if (my $data = $self->nbt_data) {
	            # $data->get_child_by_name('Delay')->payload($new_val);
            # }
        # },
    lazy => 1,
);

has 'output' => (
    is => 'rw',
    isa => 'Maybe[Minecraft::InventoryItem]',
    default => sub {
            my $self = shift;
			return $self->_get_slot_item(2);
        },
    # trigger => sub {
            # my ($self, $new_val, $old_val) = @_;
            # if (my $data = $self->nbt_data) {
	            # $data->get_child_by_name('Delay')->payload($new_val);
            # }
        # },
    lazy => 1,
);

has 'fuel' => (
    is => 'rw',
    isa => 'Maybe[Minecraft::InventoryItem]',
    default => sub {
            my $self = shift;
			return $self->_get_slot_item(1);
        },
    # trigger => sub {
            # my ($self, $new_val, $old_val) = @_;
            # if (my $data = $self->nbt_data) {
	            # $data->get_child_by_name('Delay')->payload($new_val);
            # }
        # },
    lazy => 1,
);

sub _get_slot_item{
	my $self = shift;
	my $slot = shift;
	my $items_nbt = $self->nbt_data->get_child_by_name('Items')->payload;
	for my $item_nbt (@$items_nbt) {
		if($item_nbt->get_child_by_name('Slot')->payload == $slot){
			return Minecraft::InventoryItem->new({nbt_data => $item_nbt});
		}
	}
}

1;
