package Minecraft::Util;

sub get_read_fh {
    my $filename = shift;
    require PerlIO::gzip;

    if ($filename eq __PACKAGE__) {
        $filename = shift;
    }

    my $FH;
    open $FH, "<:gzip", $filename or die $!;
    return $FH;
}

sub get_write_fh {
    my $filename = shift;
    $filename = shift if $filename eq __PACKAGE__;

    die "No file given" unless $filename;

    my $FH;
    open $FH, ">:gzip", $filename or die $!;
#    binmode $FH;
    return $FH;
}

1;
