package Minecraft::Entity::Mob::Villager;

use Mouse;
extends 'Minecraft::Entity::Mob';

use Minecraft::InventoryItem;

has 'profession' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var = $data->get_child_by_name('Profession');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Profession')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'riches' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var = $data->get_child_by_name('Riches');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Riches')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'offers' => (
    is => 'rw',
    isa => 'Maybe[ArrayRef[HashRef]]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
				if(my $nbt = $data->get_child_by_name('Offers')){
					my @result = ();
					foreach my $offer_nbt (@{$nbt->get_child_by_name('Recipes')->payload}){
						my $offerHash = {};
						if(my $item_nbt = $offer_nbt->get_child_by_name('buy')){
							$offerHash->{'buy'} = Minecraft::InventoryItem->new({nbt_data => $item_nbt});
						}
						if(my $item_nbt = $offer_nbt->get_child_by_name('buyB')){
							$offerHash->{'buyB'} = Minecraft::InventoryItem->new({nbt_data => $item_nbt});
						}
						if(my $item_nbt = $offer_nbt->get_child_by_name('sell')){
							$offerHash->{'sell'} = Minecraft::InventoryItem->new({nbt_data => $item_nbt});
						}
						if(my $item_nbt = $offer_nbt->get_child_by_name('uses')){
							$offerHash->{'uses'} = $item_nbt->payload;
						}
						if(my $item_nbt = $offer_nbt->get_child_by_name('maxUses')){
							$offerHash->{'maxUses'} = $item_nbt->payload;
						}
						push @result, $offerHash;						
					}
					return \@result;
				}
            }
			return undef;
        },
    # trigger => sub {
            # my ($self, $new_val, $old_val) = @_;
            # if (my $data = $self->nbt_data) {
	            # $data->get_child_by_name('Riches')->payload($new_val);
            # }
        # },
    lazy => 1,
);

has 'isTrading' => (
    is => 'ro',
    isa => 'Bool',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
				my $offers = $data->get_child_by_name('Offers');
                return 1 if $offers;
            }
        },
    lazy => 1,
);

1;