package Minecraft::Entity::Mob::Player;

use Minecraft::NBT;

use Mouse;
extends 'Minecraft::Entity::Mob';

has 'inventory' => (
    is => 'rw',
    isa => 'Maybe[ArrayRef]',
    default => sub { 
            my $self = shift;
            if (my $entity_data = $self->nbt_data) {
                my $inventory_nbt = $entity_data->get_child_by_name('Inventory');
                if (!$inventory_nbt) {
                    require Minecraft::NBT::List;
                    my $inventory_nbt = Minecraft::NBT::List->new({name => 'Inventory', subtag_type => 10});
                    $entity_data->add_child($inventory_nbt);
                }

                require Minecraft::InventoryItem;
                my $items = $inventory_nbt->payload || [];
                my $return = [];
                for my $item_nbt (@$items) {
                    push @$return, Minecraft::InventoryItem->new({nbt_data => $item_nbt});
                }
                return $return;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity = $self->nbt_data) {
                my $inventory_nbt = $entity->get_child_by_name('Inventory');
                if (!$inventory_nbt) {
                    $inventory_nbt = Minecraft::NBT::List->new({name => 'Inventory', subtag_type => 10});
                    $entity->add_child($inventory_nbt);
                }
                $new_val ||= [];
                my @inventory = ();
                for my $item (@$new_val) {
                    warn "Saving item";
                    push @inventory, $item->nbt_data;
                }
                $inventory_nbt->payload(\@inventory);
            }
        },
    lazy => 1,
);

has 'xp_total' => (
    is => 'rw',
    isa => 'Maybe[Int]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $xptotal_nbt = $data->get_child_by_name('XpTotal');
                return $xptotal_nbt->payload if $xptotal_nbt;
            }
			return undef;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Score')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'dimension' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 
            my $self = shift;
            return $self->level_nbt_data->get_child_by_name('Dimension')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->level_nbt_data->get_child_by_name('Dimension')->payload($new_val);
        },
    lazy => 1,
);

has 'name' => (
    is => 'rw',
    isa => 'Str',
);
# checks slots and adds item appropriately, 
#   with no slot specified, adds to first empty slot if any
sub add_item {
    my ($self, $new_item, $slot) = @_;

    my $items = $self->inventory || [];
    my $slots_taken = {};
    my $i = 0;
    for my $item (@$items) {
        $slots_taken->{$item->slot} = $i;
        $i++;
    }
    if (defined $slot) {
        if (defined $slots_taken->{$slot}) {
            $items->[$slots_taken->{$slot}] = $new_item;
            $self->inventory($items);
        } else {
            push @$items, $new_item;
            $self->inventory($items);
        }
        return $new_item;
    }

    for my $i (0..35) {
        if (!defined $slots_taken->{$i}) {
            $new_item->slot($i);
            push @$items, $new_item;
            $self->inventory($items);
            return $new_item;
        }
    }
}

# removes item from a given slot
sub clear_slot {
    my ($self, $slot) = @_;

    my $items = $self->inventory || [];
    my @new_inventory = ();
    for my $item (@$items) {
        next if $item->slot == $slot;
        push @new_inventory, $item;
    }
    $self->inventory(\@new_inventory);
}

1;
