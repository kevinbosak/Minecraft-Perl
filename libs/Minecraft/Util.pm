package Minecraft::Util;

sub get_read_fh {
    my $filename = shift;

    $filename = shift if ($filename eq __PACKAGE__);
    die "No file given" unless $filename;

    require PerlIO::gzip;

    my $FH;
    open $FH, "<:gzip", $filename or die $!;
    return $FH;
}

sub get_write_fh {
    my $filename = shift;

    $filename = shift if $filename eq __PACKAGE__;
    die "No file given" unless $filename;

    require PerlIO::gzip;

    my $FH;
    open $FH, ">:gzip", $filename or die $!;
#    binmode $FH;
    return $FH;
}

1;
