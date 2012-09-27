package Minecraft::NBT;

use Minecraft::Util;

use Mouse;
use Readonly;
use Data::Dumper;
use Math::BigInt;
use Compress::Zlib;

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
require Minecraft::NBT::String;
require Minecraft::NBT::List;
require Minecraft::NBT::Compound;
require Minecraft::NBT::IntArray;

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
	11 => 'TAG_INT_ARRAY',
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

sub unzip_data {
    my $data = shift;
    if ($data eq __PACKAGE__) {
        $data = shift;
    }

    # gzopen needs a filehandle, so make one
    my $fh;
    open ($fh, '+<', \$data);

    my $gz = gzopen($fh, 'rb');
    my $buffer;
    my $return = '';
    while ($gz->gzread($buffer)) {
        $return .= $buffer;
    }
    $return .= $buffer;
    close $fh;
    return $return;
}

# pulls the nbt raw data from raw data and converts it to objects
sub parse_data {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }
    my $data = $args->{data} if $args;
    die "No data given" unless $$data && length($$data);

    my $tag_type = $args->{tag_type};
	
    my $tag_data = {};
    # get the tag name

    
    if (!defined $tag_type) {
        my $type_data = parse_data({data => $data, tag_type => string_to_type('TAG_BYTE')});
        $tag_type = $type_data->payload;
    }
	
    die "NO TAG TYPE" unless defined $tag_type;

    return if type_to_string($tag_type) eq 'TAG_END';
	
	my $has_name = $args->{is_named};
    # get the tag's name
    if ($has_name) {
        my $name_data = parse_data({data => $data, tag_type => string_to_type('TAG_STRING')});
        my $tag_name = $name_data->payload;
        $tag_data->{name} = $tag_name;
		#print type_to_string($tag_type).":'$tag_name'\n";
    }	
	
    # get the payload
    my $payload;
    if (type_to_string($tag_type) eq 'TAG_COMPOUND') {
        my @tags = ();
        while (my $subtag = parse_data({data => $data, is_named => 1})) {
            push @tags, $subtag;
        }
        $payload = \@tags;

    } elsif (type_to_string($tag_type) eq 'TAG_BYTE') {
        my $payload_data = substr($$data, 0, 1, '');
        ($payload) = unpack('c', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_SHORT') {
        my $payload_data = substr($$data, 0, 2, '');
        ($payload) = unpack('s>', $payload_data);

    } elsif (type_to_string($tag_type) eq'TAG_INT') {
        my $payload_data = substr($$data, 0, 4, '');
        ($payload) = unpack('l>', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_LONG') {
        my $byte_string = '';
        my @bytes = ();
        for (1..8) {
            my $byte = substr($$data, 0, 1, '');
            my ($byte_string) = unpack('B*', $byte);
            push @bytes, $byte_string;
        }
        $payload = Math::BigInt->new('0b' . join('', @bytes));

    } elsif (type_to_string($tag_type) eq 'TAG_FLOAT') {
        my $payload_data = substr($$data, 0, 4, '');
        ($payload) = unpack('f>', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_DOUBLE') {
        my $payload_data = substr($$data, 0, 8, '');
        ($payload) = unpack('d>', $payload_data);

    } elsif (type_to_string($tag_type) eq 'TAG_BYTE_ARRAY') {
        my $length_data = parse_data({data => $data, tag_type => string_to_type('TAG_INT')});
        my $length = $length_data->payload;

        my $payload_data = substr($$data, 0, $length, '');
        $payload = $payload_data;

    } elsif (type_to_string($tag_type) eq 'TAG_INT_ARRAY') {
        my $length_data = parse_data({data => $data, tag_type => string_to_type('TAG_INT')});
        my $length = $length_data->payload;
		
        my $payload_data = substr($$data, 0, $length * 4, '');
		($payload) = [unpack("N*",$payload_data)];
	
	} elsif (type_to_string($tag_type) eq 'TAG_STRING') {
        my $length_data = parse_data({data => $data, tag_type => string_to_type('TAG_SHORT')});
        my $length = $length_data->payload;

        my $payload_data = substr($$data, 0, $length, '');
        $payload = $payload_data;
        utf8::upgrade($payload);

    } elsif (type_to_string($tag_type) eq 'TAG_LIST') {
        my $id_data = parse_data({data => $data, tag_type => string_to_type('TAG_BYTE')});
        my $id = $id_data->payload;
        $tag_data->{subtag_type} = $id;

        my $length_data = parse_data({data => $data, tag_type => string_to_type('TAG_INT')});
        my $length = $length_data->payload;

        my @tags = ();
        for (1..$length) {
            my $tag_data = parse_data({data => $data, tag_type => $id});
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

    my $FH;
    open($FH, "<", $filename) or die "Could not open $filename";
    binmode $FH;
    my $data;
    {
        local $/;
        $data = <$FH>;
    }
    close $FH;

    if ($args->{is_compressed}) {
        $data = unzip_data($data);
        delete $args->{is_compressed};
    }

    $args->{data} = \$data;
    
    my $return = parse_data($args);
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
    
    if (ref $self->payload && ref $self->payload eq 'ARRAY') {
        my $length = scalar @{$self->payload};
        $string .= "$length entries";

        $string .= "\n${leader}{";

        for my $obj (@{$self->payload}) {
           $string .= "\n" . $obj->as_string($leader . '    ');
        }

        $string .= "\n${leader}}";

    } elsif (ref $self->payload && ref $self->payload eq 'HASH') {
        my $length = scalar keys %{$self->payload};
        $string .= "$length entries";

        $string .= "\n${leader}{";

        for my $obj (values %{$self->payload}) {
           $string .= "\n" . $obj->as_string($leader . '    ');
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
#        $return .= pack('q>', $self->payload);
        my $byte_string = $self->payload->as_bin;

        substr($byte_string, 0, 2, '');
        # zero-pad
        if (my $diff = 64 - length($byte_string)) {
            my $string = ('0') x $diff;
            $byte_string = $string . $byte_string;
        }

        my @bytes = ();
        while (length($byte_string)) {
            my $byte = substr($byte_string, 0, 8, '');
	    $return .= pack('B*', $byte);
        }

    } elsif (type_to_string($self->tag_type) eq 'TAG_FLOAT') {
        $return .= pack('f>', $self->payload);

    } elsif (type_to_string($self->tag_type) eq 'TAG_DOUBLE') {
        $return .= pack('d>', $self->payload);

    } elsif (type_to_string($self->tag_type) eq 'TAG_BYTE_ARRAY') {
        # length
        my $length = $self->payload ? length $self->payload : 0;
        $return .= Minecraft::NBT::Int->new({payload => $length})->as_nbt;

        # payload
        my $payload = $self->payload;
        $return .= $payload;

    } elsif (type_to_string($self->tag_type) eq 'TAG_STRING') {
        my $payload = $self->payload;
        utf8::downgrade($payload);
        my $length = length($self->payload);

        # length
        $return .= Minecraft::NBT::Short->new({payload => $length})->as_nbt;

        $return .= $payload;

    } elsif (type_to_string($self->tag_type) eq 'TAG_LIST') {
        $return .= Minecraft::NBT::Byte->new({payload => $self->subtag_type})->as_nbt;

        my $length = $self->payload ? scalar @{$self->payload} : 0;
        $return .= Minecraft::NBT::Int->new({payload => $length})->as_nbt;

        my @tags = ();
        for my $tag (@{$self->payload}) {
            $return .= $tag->as_nbt if $tag;
        }

    } elsif (type_to_string($self->tag_type) eq 'TAG_COMPOUND') {
        # only give payload
        for my $tag (@{$self->payload}) {
            $return .= $tag->as_nbt;
        }
        $return .= Minecraft::NBT::Byte->new({payload => string_to_type('TAG_END')})->as_nbt;
    }

    return $return;
}

1;

=head1 NAME

Minecraft::NBT - Tag base class for Minecraft NBT files.

=head1 VERSION

This documentation refers to Minecraft::NBT version $Revision$

=head1 SYNOPSIS

    use Minecraft::NBT;

    my $root_tag = Minecraft::NBT::parse_from_file({file => 'world/local.dat'});
    print $root_tag->name . "\n"; # root tag is named but the name is generally empty
    print $root_tag->as_string . "\n";
    print Minecraft::NBT::type_to_string($root_tag->tag_type) . "\n";
    my $data = $nbt->payload; # can be other NBT tags or string/int/etc. depending on the type of tag


=head1 DESCRIPTION

This module is the base class for all NBT tag objects.  It also includes several
helper functions for reading NBT data and parsing it into tag objects. This class
is subclassed by the various NBT data types.

=head1 SUBROUTINES

=head2 parse_from_file({file => $filename})
=head2 parse_from_fh({fh => $filehandle, is_named => 1, tag_type => 1})

Parses and returns the root NBT tag for the data in the given NBT file. parse_from_fh can optionally 
take 'is_named' and 'tag_type' to tell whether the next tag in the stream is a named tag and what
type it is.

=head2 types_hash

Returns a hash of NBT data types with the keys being the data type value and the values being
a string representation.

=head2 string_to_type($string)
=head2 type_to_type($type)

Convert to/from the human-readable strings and NBT codes for data types.

=head1 ATTRIBUTES

=head2 name

The name of the tag, if this is a named tag

=head2 tag_type

The NBT code for the tag type

=head2 payload

The tag's payload, which can be another NBT tag, an arrayref of tags, or a scalar.

=head1 OBJECT METHODS

=head2 as_string

Returns a string representation of the NBT tag and its children, if any.

=head2 as_nbt

Returns the binary representation of the NBT tag and its children, if any. Use
this for writing to a file

=head1 SEE ALSO

Minecraft::NBT::Byte

Minecraft::NBT::Short

Minecraft::NBT::Int

Minecraft::NBT::Long

Minecraft::NBT::Double

Minecraft::NBT::Float

Minecraft::NBT::String

Minecraft::NBT::Compound

Minecraft::NBT::List

Minecraft::NBT::ByteArray

=head1 AUTHOR

Kevin Bosak
