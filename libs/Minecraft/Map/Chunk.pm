package Minecraft::Map::Chunk;

use Mouse;

use Minecraft::Entity;
use Minecraft::TileEntity;

has 'chunk_nbt_data' => (
    is => 'rw',
    isa => 'Minecraft::NBT',
);

has 'blocks' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    default => sub { 
            my $self = shift;
			if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $self->get_tag_from_sections('Blocks');
				my @blocks = unpack('W*', $block_data);
				#my @blocks = split(//,"$block_data");
				return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = pack('C*', @$new_val);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('Blocks')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'data' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('Data')->payload;
                my $block_string = unpack('H*', $block_data);
                my @blocks = split('', $block_string);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my @blocks = join('', @$new_val);
                my $block_data = pack('H*', @blocks);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('Data')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'sky_light' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('SkyLight')->payload;
                my $block_string = unpack('H*', $block_data);
                my @blocks = split('', $block_string);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my @blocks = join('', @$new_val);
                my $block_data = pack('H*', @blocks);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('SkyLight')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'block_light' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('BlockLight')->payload;
                my $block_string = unpack('H*', $block_data);
                my @blocks = split('', $block_string);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my @blocks = join('', @$new_val);
                my $block_data = pack('H*', @blocks);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('BlockLight')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'height_map' => (
    is => 'rw',
    isa => 'ArrayRef[Int]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = $chunk_data->get_child_by_name('Level')->get_child_by_name('HeightMap')->payload;
                my @blocks = unpack('C*', $block_data);
                return \@blocks;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $block_data = pack('C*', @$new_val);
	            $chunk_data->get_child_by_name('Level')->get_child_by_name('HeightMap')->payload($block_data);
            }
        },
    lazy => 1,
);

has 'entities' => (
    is => 'rw',
    isa => 'Maybe[ArrayRef]',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $entities_nbt = $chunk_data->get_child_by_name('Level')->get_child_by_name('Entities');
                if ($entities_nbt) {
                    my $entities = $entities_nbt->payload;
                    my $return = [];
                    for my $entity_nbt (@$entities) {
                        push @$return, Minecraft::Entity->new({entity_nbt_data => $entity_nbt});
                    }
                    return $return;
                }
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $entity_nbt = $chunk_data->get_child_by_name('Entities');
                if (my $entities = $self->entities) {
                    my $return = [];
                    for my $entity (@$entities) {
                        push @$return, $entity->entity_nbt_data;
                    }
                    $entity_nbt ||= Minecraft::NBT::List->new({name => 'Entities', subtag_type => 10});
                    $entity_nbt->payload($return);
                } else {
                    # make sure the entities nbt is gone from the chunk
                }
            }
        },
);

has 'tile_entities' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { 
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $entities_nbt = $chunk_data->get_child_by_name('Level')->get_child_by_name('TileEntities');
                if ($entities_nbt) {
                    my $entities = $entities_nbt->payload;
                    my $return = [];
                    for my $entity_nbt (@$entities) {
                        push @$return, Minecraft::TileEntity->new({entity_nbt_data => $entity_nbt});
                    }
                    return $return;
                }
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
                my $entity_nbt = $chunk_data->get_child_by_name('TileEntities');
                if (my $entities = $self->entities) {
                    my $return = [];
                    for my $entity (@$entities) {
                        push @$return, $entity->entity_nbt_data;
                    }
                    $entity_nbt ||= Minecraft::NBT::List->new({name => 'TileEntities', subtag_type => 10});
                    $entity_nbt->payload($return);
                } else {
                    # make sure the entities nbt is gone from the chunk
                }
            }
        },
);

has 'last_update' => (
    is => 'rw',
    isa => 'Math::BigInt',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('LastUpdate')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
	            $chunk_data->get_child_by_name('LastUpdate')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'timestamp' => (
    is => 'rw',
    isa => 'Int',
    # default => sub {
            # my $self = shift;
            # if (my $chunk_data = $self->chunk_nbt_data) {
                # return $chunk_data->get_child_by_name('Level')->get_child_by_name('LastUpdate')->payload;
            # }
        # },
    # trigger => sub {
            # my ($self, $new_val, $old_val) = @_;
            # if (my $chunk_data = $self->chunk_nbt_data) {
	            # $chunk_data->get_child_by_name('LastUpdate')->payload($new_val);
            # }
        # },
    # lazy => 1,
);

has 'x_pos' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('xPos')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
	            $chunk_data->get_child_by_name('xPos')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'z_pos' => (
    is => 'rw',
    isa => 'Int',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('zPos')->payload;
            }
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
	            $chunk_data->get_child_by_name('zPos')->payload($new_val);
            }
        },
    lazy => 1,
);

has 'terrain_populated' => (
    is => 'rw',
    isa => 'Bool',
    default => sub {
            my $self = shift;
            if (my $chunk_data = $self->chunk_nbt_data) {
                return $chunk_data->get_child_by_name('Level')->get_child_by_name('TerrainPopulated')->payload;
            }
            return 0;
        },
    trigger => sub {
            my ($self, $new_val, $old_val) = @_;
            if (my $chunk_data = $self->chunk_nbt_data) {
	            $chunk_data->get_child_by_name('TerrainPopulated')->payload($new_val);
            }
        },
    lazy => 1,
);

sub get_tag_from_sections {
	my $self = shift;
	my $tag_name = shift;
    if (my $chunk_data = $self->chunk_nbt_data) {
		my $sections = $chunk_data->get_child_by_name('Level')->get_child_by_name('Sections')->payload;
		my $return = '';
		foreach my $section (@$sections){
			$return .= $section->get_child_by_name($tag_name)->payload;
			my $Y = $section->get_child_by_name('Y')->payload;
			#print "Section $Y: ".length($return)."\n";
		}
		return $return;
	}
}

sub get_block_type {
    my ($self, $x, $y, $z) = @_;
    die "Must specify x, y, and z" unless defined $x && defined $z && defined $y;

    my $blocks = $self->blocks;
    return unless $blocks && scalar @$blocks;

    my $i = $y*16*16 + $z*16 + $x;
	return $blocks->[$i];
}

sub get_block_height {
    my ($self, $x, $z) = @_;
    die "Must specify x, and z" unless defined $x && defined $z;

    my $blocks = $self->height_map;
    return unless $blocks && scalar @$blocks;

    my $i = $x + $z*16;
    return $blocks->[$i];
}

# This could be used when an NBT object was not used to initialize this object
# ie. creating a new chunk from scratch
sub as_nbt_object {
    my $self = shift;

    # get entities as nbt objs
    # get tile_entities as nbt objs
    # create a wrapper object
}

# return the internal nbt object wrapped in the necessary compound tag and converted to raw data
sub as_nbt_data {
    my $self = shift;
    require Minecraft::NBT::Compound;

    my $nbt = Minecraft::NBT::Compound->new({name => '', payload => [$self->chunk_nbt_data]});
    return $nbt->as_nbt;
}

1;
