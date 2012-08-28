package Minecraft::TileEntity::MobSpawner;

use Mouse;
extends 'Minecraft::TileEntity';

has 'entity_id' => (
    is => 'rw',
    isa => 'Str',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var =$data->get_child_by_name('EntityId');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('EntityId')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'spawn_count' => (
    is => 'rw',
    isa => 'Num',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var =$data->get_child_by_name('SpawnCount');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('SpawnCount')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'delay' => (
    is => 'rw',
    isa => 'Num',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var =$data->get_child_by_name('Delay');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Delay')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'min_spawn_delay' => (
    is => 'rw',
    isa => 'Num',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var =$data->get_child_by_name('MinSpawnDelay');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('MinSpawnDelay')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'max_spawn_delay' => (
    is => 'rw',
    isa => 'Num',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $var =$data->get_child_by_name('MaxSpawnDelay');
                return $var->payload if $var;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('MaxSpawnDelay')->payload($new_val);
            }
        },
    lazy => 1,
);


1;
