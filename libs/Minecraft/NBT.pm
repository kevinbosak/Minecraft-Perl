package Minecraft::NBT;

use Minecraft::Util;

use Mouse;
use Readonly;
use Data::Dumper;
use Encode;

has 'name' => (
    is => 'rw',
    isa => 'Maybe[Str]',
);

has 'tag_type' => (
    is => 'ro',
    isa => 'Int',
    default => '',
);

has 'payload' => (
    is => 'rw',
);

# TODO:
# file, path, x/y Position?

require Minecraft::NBT::Byte;
require Minecraft::NBT::Short;
require Minecraft::NBT::Int;
require Minecraft::NBT::Long;
require Minecraft::NBT::Float;
require Minecraft::NBT::Double;
require Minecraft::NBT::ByteArray;
require Minecraft::NBT::List;
require Minecraft::NBT::Compound;
require Minecraft::NBT::String;

Readonly my %TYPES => (
     0 => 'TAG_END',
     1 => 'TAG_BYTE',
     2 => 'TAG_SHORT',
     3 => 'TAG_INT',
     4 => 'TAG_LONG',
     5 => 'TAG_FLOAT',
     6 => 'TAG_DOUBLE',
     7 => 'TAG_BYTE_ARRAY',
     8 => 'TAG_STRING',
     9 => 'TAG_LIST',
    10 => 'TAG_COMPOUND',
);

sub types_hash {
    return %TYPES;
}

sub string_to_type {
    my $string = shift;
    my %types = reverse %TYPES;
    return $types{$string};
}

sub type_to_string {
    my $type = shift;
    return $TYPES{$type};
}

# pulls the nbt raw data from an open filehandle and converts it to objects
sub parse_from_fh { # TOOD: make this more generic?
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }
    my $fh = $args->{fh} if $args;
    die "No file handle given" unless $fh;

    my $tag_type = $args->{tag_type};

    my $tag_data = {};
    # get the tag name

    my $has_name = $args->{is_named};
    if (!defined $tag_type) {
        my $type_data = parse_from_fh({fh => $fh, tag_type => string_to_type('TAG_BYTE')});
        $tag_type = $type_data->payload;
    }
    die "NO TAG TYPE" unless defined $tag_type;

    return if type_to_string($tag_type) eq 'TAG_END';

    # get the tag's name
    if ($has_name) {
        my $name_data = parse_from_fh({fh => $fh, tag_type => string_to_type('TAG_STRING')});
        my $tag_name = $name_data->payload;
        $tag_data->{name} = $tag_name;
    }

    # get the payload
    my $payload;
    if (type_to_string($tag_type) eq 'TAG_COMPOUND') {
        my @tags = ();
        while (my $subtag = parse_from_fh({fh => $fh, is_named => 1})) {
            push @tags, $subtag;
        }
        $payload = \@tags;

    } elsif (type_to_string($tag_type) eq 'TAG_BYTE') {
        my $payload_data;
        read($fh, $payload_data, 1);
        ($payload) = unpack('c', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_SHORT') {
        my $payload_data;
        read($fh, $payload_data, 2);
        ($payload) = unpack('s>', $payload_data);

    } elsif (type_to_string($tag_type) eq'TAG_INT') {
        my $payload_data;
        read($fh, $payload_data, 4);
        ($payload) = unpack('l>', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_LONG') {
        my $payload_data;
        read($fh, $payload_data, 8);
        ($payload) = unpack('q>', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_FLOAT') {
        my $payload_data;
        read($fh, $payload_data, 4);
        ($payload) = unpack('f>', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_DOUBLE') {
        my $payload_data;
        read($fh, $payload_data, 8);
        ($payload) = unpack('d>', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_BYTE_ARRAY') {
        my $length_data = parse_from_fh({fh => $fh, tag_type => string_to_type('TAG_INT')});
        my $length = $length_data->payload;

        my @bytes = ();
        for (1..$length) {
            my $byte = parse_from_fh({fh => $fh, tag_type => string_to_type('TAG_BYTE')});
            push @bytes, $byte;
        }
        $payload = \@bytes;

    } elsif (type_to_string($tag_type) eq 'TAG_STRING') {
        my $length_data = parse_from_fh({fh => $fh, tag_type => string_to_type('TAG_SHORT')});
        my $length = $length_data->payload;

        my $payload_data;
        read($fh, $payload_data, $length);
        $payload = Encode::decode('UTF-8', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_LIST') {
        my $id_data = parse_from_fh({fh => $fh, tag_type => string_to_type('TAG_BYTE')});
        my $id = $id_data->payload;
        $tag_data->{subtag_type} = $id;

        my $length_data = parse_from_fh({fh => $fh, tag_type => string_to_type('TAG_INT')});
        my $length = $length_data->payload;

        my @tags = ();
        for (1..$length) {
            my $tag_data = parse_from_fh({fh => $fh, tag_type => $id});
            push @tags, $tag_data;
        }
        $payload = \@tags;
    }
    $tag_data->{payload} = $payload;

    my $type_string = type_to_string($tag_type);
    my @parts = split('_', $type_string);
    shift @parts;
    $type_string = join('', map {ucfirst(lc($_))} @parts);
    my $pkg = __PACKAGE__ . "::$type_string";

    my $tag_obj;
    eval {$tag_obj = $pkg->new($tag_data)};
    die $@ if $@;
    return $tag_obj;
}

sub parse_from_file {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }
    my $filename = delete $args->{file} if $args;
    die "No file given" unless $filename;
    die "File not found" unless -e $filename;

    $args->{fh} = Minecraft::Util::get_read_fh($filename);
    my $return = parse_from_fh($args);
    close $args->{fh};
    return $return;
}

sub as_string {
    my $self = shift;
    my $leader = shift || '';

    my $string = $leader;

    my ($blah, $type) = split('_', type_to_string($self->tag_type));
    $type = ucfirst(lc($type));
    $string .= "TAG_$type";

    if ($self->name) {
        $string .= '("' . $self->name . '")';
    }
    $string .= ': ';
    
    if (ref $self->payload) {
        my $length = scalar @{$self->payload};
        $string .= "$length entries";

        $string .= "\n${leader}{";

        for my $obj (@{$self->payload}) {
           $string .= "\n${leader}" . $obj->as_string($leader . '    ');
        }

        $string .= "\n${leader}}";
    } else {
        $string .= $self->payload;
#    $string .= "\n";
    }
    return $string;
}

# returns the raw bits to write to an nbt file
sub as_nbt {
    my $self = shift;

    my $return = '';
    # write name and tag type if this is a named tag
    if (defined $self->name) {
        # write the type
        $return .= Minecraft::NBT::Byte->new({payload => $self->tag_type})->as_nbt;
        # write the name
        $return .= Minecraft::NBT::String->new({payload => $self->name})->as_nbt;
    }

    # now for the payload
    if (type_to_string($self->tag_type) eq 'TAG_BYTE') {
        $return .= pack('c', $self->payload);

    } elsif (type_to_string($self->tag_type) eq 'TAG_SHORT') {
        $return .= pack('s>', $self->payload);

    } elsif (type_to_string($self->tag_type) eq'TAG_INT') {
        $return .= pack('l>', $self->payload);

    } elsif (type_to_string($self->tag_type) eq 'TAG_LONG') {
        $return .= pack('q>', $self->payload);

    } elsif (type_to_string($self->tag_type) eq 'TAG_FLOAT') {
        $return .= pack('f>', $self->payload);

    } elsif (type_to_string($self->tag_type) eq 'TAG_DOUBLE') {
        $return .= pack('d>', $self->payload);

    } elsif (type_to_string($self->tag_type) eq 'TAG_BYTE_ARRAY') {
        # length
        my $length = $self->payload ? scalar @{$self->payload} : 0;
        $return .= Minecraft::NBT::Int->new({payload => $length})->as_nbt;

        # payload
        for my $byte (@{$self->payload}) {
            $return .= $byte->as_nbt;
        }

    } elsif (type_to_string($self->tag_type) eq 'TAG_STRING') {
        my $payload = Encode::encode('UTF-8', $self->payload);
        # length
#        my $payload = $self->payload;
        $return .= Minecraft::NBT::Short->new({payload => length($payload)})->as_nbt;

        $return .= $payload;

    } elsif (type_to_string($self->tag_type) eq 'TAG_LIST') {
        $return .= Minecraft::NBT::Byte->new({payload => $self->subtag_type})->as_nbt;

        my $length = $self->payload ? scalar @{$self->payload} : 0;
        $return .= Minecraft::NBT::Int->new({payload => $length})->as_nbt;

        my @tags = ();
        for my $tag (@{$self->payload}) {
            $return .= $tag->as_nbt;
        }

    } elsif (type_to_string($self->tag_type) eq 'TAG_COMPOUND') {
        # only give payload
        for my $named_tag (@{$self->payload}) {
            $return .= $named_tag->as_nbt;
        }
        $return .= Minecraft::NBT::Byte->new({payload => string_to_type('TAG_END')})->as_nbt;
    }

    return $return;
}

1;
