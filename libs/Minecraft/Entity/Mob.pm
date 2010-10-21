package Minecraft::Entity::Mob;

use Mouse;
extends 'Minecraft::Entity';

has 'attack_time' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $entity_data = $self->entity_nbt_data) {
                return $entity_data->get_child_by_name('AttackTime')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity_data = $self->entity_nbt_data) {
	            $entity_data->get_child_by_name('AttackTime')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'death_time' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $entity_data = $self->entity_nbt_data) {
                return $entity_data->get_child_by_name('DeathTime')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity_data = $self->entity_nbt_data) {
	            $entity_data->get_child_by_name('DeathTime')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'health' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $entity_data = $self->entity_nbt_data) {
                return $entity_data->get_child_by_name('Health')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity_data = $self->entity_nbt_data) {
	            $entity_data->get_child_by_name('Health')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'hurt_time' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $entity_data = $self->entity_nbt_data) {
                return $entity_data->get_child_by_name('HurtTime')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity_data = $self->entity_nbt_data) {
	            $entity_data->get_child_by_name('HurtTime')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'saddle' => ( # for pigs
    is => 'rw',
    isa => 'Maybe[Bool]',
    default => sub {
            my $self = shift;
            if (my $entity_data = $self->entity_nbt_data) {
                return $entity_data->get_child_by_name('Saddle')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity_data = $self->entity_nbt_data) {
	            $entity_data->get_child_by_name('Saddle')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'sheared' => ( # for sheep
    is => 'rw',
    isa => 'Maybe[Bool]',
    default => sub {
            my $self = shift;
            if (my $entity_data = $self->entity_nbt_data) {
                return $entity_data->get_child_by_name('Sheared')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity_data = $self->entity_nbt_data) {
	            $entity_data->get_child_by_name('Sheared')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'size' => ( # size of slime
    is => 'rw',
    isa => 'Maybe[Int]',
    default => sub {
            my $self = shift;
            if (my $entity_data = $self->entity_nbt_data) {
                return $entity_data->get_child_by_name('Size')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $entity_data = $self->entity_nbt_data) {
	            $entity_data->get_child_by_name('Size')->payload($new_val);
            }
        },
    lazy => 1,
);

1;
