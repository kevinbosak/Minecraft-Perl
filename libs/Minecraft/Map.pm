package Minecraft::Map;

use Minecraft::Util;
use Minecraft::NBT;
use Minecraft::Entity::Mob::Player;

use Mouse;

# use this to pull data when available 
has 'nbt_data' => (
    is => 'rw',
    isa => 'Maybe[Minecraft::NBT]',
    # TODO: make this required?
);

has 'path' => (
    is => 'rw',
    isa => 'Str',
);

has 'name' => (
    is => 'rw',
    isa => 'Str',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('LevelName')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('LevelName')->payload($new_val);
        },
    lazy => 1,
);

has 'time' => (
    is => 'rw',
    isa => 'Math::BigInt',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('Time')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('Time')->payload($new_val);
        },
    lazy => 1,
);

has 'last_played' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('LastPlayed')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('LastPlayed')->payload($new_val);
        },
    lazy => 1,
);

has 'player' => (
    is => 'rw',
    isa => 'Minecraft::Entity::Mob::Player',
    default => sub { 
            my $self = shift;
			my $player = $self->nbt_data->get_child_by_name('Player');
            return Minecraft::Entity::Mob::Player->new({nbt_data=>$player}) if $player;
            return undef;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('Player')->payload($new_val);
        },
    lazy => 1,
);

has 'spawn_x' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('SpawnX')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('SpawnX')->payload($new_val);
        },
    lazy => 1,
);

has 'spawn_y' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('SpawnY')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('SpawnY')->payload($new_val);
        },
    lazy => 1,
);

has 'spawn_z' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('SpawnZ')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('SpawnZ')->payload($new_val);
        },
    lazy => 1,
);

has 'size_on_disk' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('SizeOnDisk')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('SizeOnDisk')->payload($new_val);
        },
    lazy => 1,
);

has 'random_seed' => (
    is => 'rw',
    isa => 'Int',
    default => sub { 
            my $self = shift;
            return $self->nbt_data->get_child_by_name('RandomSeed')->payload;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            $self->nbt_data->get_child_by_name('RandomSeed')->payload($new_val);
        },
    lazy => 1,
);

has 'chunks' => (
    is => 'rw',
    isa => 'Maybe[HashRef]',
    default => sub {return {}},
);

has 'players' => (
    is => 'rw',
    isa => 'ArrayRef[Minecraft::Entity::Mob::Player]',
    default => sub {return []},
    lazy => 1,
);

sub _chunk_key {
    my ($self, $chunk_x, $chunk_z) = @_;
    return join(',', $chunk_x, $chunk_z);
}

sub get_chunk {
    my ($self, $chunk_x, $chunk_z) = @_;

    my $key = $self->_chunk_key($chunk_x, $chunk_z);

    if (my $chunk = $self->chunks->{$key}) {
        return $chunk;
    }

    if ($self->path && -e $self->path) {
        my $chunk = Minecraft::Util::load_chunk_from_file({
            world_path => $self->path,
            chunk_x => $chunk_x,
            chunk_z => $chunk_z,
        });
        $self->chunks->{$key} = $chunk if $chunk;
    }
}

sub add_player {
	my ($self, $player) = @_;
    return unless defined $player;
	my @playerarr = @{$self->players};
	push(@playerarr, $player);
	$self->players(\@playerarr);
}

sub set_chunk {
    my ($self, $chunk_x, $chunk_z, $chunk) = @_;
    return unless defined $chunk_x && defined $chunk_z && defined $chunk;

    my $key = $self->_chunk_key($chunk_x, $chunk_z);
    $self->chunks->{$key} = $chunk;

    return $chunk
}

# parses the 'world' folder of a map
sub parse_from_dir {  # TODO: rename to 'new_from_path'?
    my $args = shift;
    $args = shift if ! ref $args;

    die "No args given" unless $args && ref $args;

    my $path = $args->{path};
    die "No valid path given" unless $path && -d $path;

    chop $path if substr($path, -1, 1) eq '/';

    require Minecraft::NBT;

    my $level_data = Minecraft::NBT->parse_from_file({file => "$path/level.dat", is_named => 1, is_compressed => 1})->payload->[0];
    # TODO get players from nbt and put into Map objectx
    my $map = Minecraft::Map->new({nbt_data => $level_data, path => $path});

    return $map;
}

1;
