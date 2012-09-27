package Minecraft::TileEntity::Chest;

use Mouse;
extends 'Minecraft::TileEntity';

has 'items' => (
    is => 'rw',
    isa => 'Maybe[ArrayRef]',
    default => sub { 
            my $self = shift;
            if (my $entity_data = $self->nbt_data) {
                my $inventory_nbt = $entity_data->get_child_by_name('Items');
                if (!$inventory_nbt) {
                    require Minecraft::NBT::List;
                    my $inventory_nbt = Minecraft::NBT::List->new({name => 'Items', subtag_type => 10});
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
                my $inventory_nbt = $entity->get_child_by_name('Items');
                if (!$inventory_nbt) {
                    $inventory_nbt = Minecraft::NBT::List->new({name => 'Items', subtag_type => 10});
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

1;
