package Minecraft::Map::Util;

sub get_chunk_path {
    my $args = shift;
    if (!ref $args) {
        $args = shift;
    }

    my $x_pos = $args->{x_pos};
    my $y_pos = $args->{y_pos};

    die "Must give x and y positions" unless (defined $x_pos && defined $y_pos);

    my $mod_64_x = $x_pos % 64;
    my $mod_64_y = $y_pos % 64;

    my $base_mod_x = _base_36($mod_64_x);
    my $base_mod_y = _base_36($mod_64_y);

    my $base_x = _base_36($x_pos);
    my $base_y = _base_36($y_pos);

    return "$base_mod_x/$base_mod_y/c.$base_x.$base_y.dat";
}

sub _base_36 {
    my $n = shift;
    return(0) if $n == 0;

    my $negative = 0;
    if ($n < 0) {
        $n = -1 * $n;
        $negative = 1;
    }

    my $s = '';
    while ( $n ) {
        my $v = $n % 36;
        if ($v <= 9) {
            $s .= $v;
        } else {
            $s .= chr(55 + $v); # Assume that 'A' is 65
        }
            $n = int $n / 36;
    }
    my $return = reverse $s;
    $return = '-' . $return if $negative;
    return lc($return);
}

1;
