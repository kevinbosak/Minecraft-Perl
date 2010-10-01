package Minecraft::NBT;

use Moose;
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

# To be overridden 

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

sub as_nbt {
}

1;
