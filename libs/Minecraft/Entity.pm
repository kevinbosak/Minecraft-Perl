package Minecraft::Entity;

use Mouse;

has 'nbt_data' => (
    is => 'rw',
    isa => 'Minecraft::NBT::Compound',
);

has 'id' => (
    is => 'rw',
    isa => 'Maybe[Str]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $id = $data->get_child_by_name('id');
                return $id->payload if $id;
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

has 'pos' => (
    is => 'rw',
    isa => 'ArrayRef[Num]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $pos = $data->get_child_by_name('Pos')->payload;
                return [$pos->[0]->payload, $pos->[1]->payload, $pos->[2]->payload];
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            my $pos =$data->get_child_by_name('Pos')->payload;
                $pos->[0]->payload($new_val->[0]);
                $pos->[1]->payload($new_val->[1]);
                $pos->[2]->payload($new_val->[2]);
            }
        },
    lazy => 1,
);

has 'motion' => (
    is => 'rw',
    isa => 'ArrayRef[Num]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $pos = $data->get_child_by_name('Motion')->payload;
                return [$pos->[0]->payload, $pos->[1]->payload, $pos->[2]->payload];
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            my $pos =$data->get_child_by_name('Motion')->payload;
                $pos->[0]->payload($new_val->[0]);
                $pos->[1]->payload($new_val->[1]);
                $pos->[2]->payload($new_val->[2]);
            }
        },
);

has 'rotation' => (
    is => 'rw',
    isa => 'ArrayRef[Num]',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                my $pos = $data->get_child_by_name('Rotation')->payload;
                return [$pos->[0]->payload, $pos->[1]->payload];
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            my $pos =$data->get_child_by_name('Rotation')->payload;
                $pos->[0]->payload($new_val->[0]);
                $pos->[1]->payload($new_val->[1]);
            }
        },
);

has 'fall_distance' => (
    is => 'rw',
    isa => 'Num',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                return $data->get_child_by_name('FallDistance')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('FallDistance')->payload($new_val);
            }
        },
);

has 'fire' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                return $data->get_child_by_name('Fire')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Fire')->payload($new_val);
            }
        },
);

has 'air' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                return $data->get_child_by_name('Air')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('Air')->payload($new_val);
            }
        },
);

has 'on_ground' => (
    is => 'rw',
    isa => 'Bool',
    default => sub {
            my $self = shift;
            if (my $data = $self->nbt_data) {
                return $data->get_child_by_name('OnGround')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $data = $self->nbt_data) {
	            $data->get_child_by_name('OnGround')->payload($new_val);
            }
        },
);

sub as_nbt_data {
    my $self = shift;
    require Minecraft::NBT::Compound;

    my $nbt = Minecraft::NBT::Compound->new({name => '', payload => [$self->nbt_data]});
    return $nbt->as_nbt;
}

1;
