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

=head1 NAME

Minecraft::Util - Helper functions for common minecraft-related commands.

=head1 VERSION

This documentation refers to Minecraft::Util version $Revision$

=head1 SYNOPSIS

    use Minecraft::Util;

    my $FH = Minecraft::Util::get_read_fh('world/local.dat');
    my $FH = Minecraft::Util::get_write_fh('world/local.dat');

=head1 DESCRIPTION

This module provides various utility functions for Minecraft-related data.  
Currently it only opens and auto-(un)gzips files.  This is done using 
PerlIO::gzip which cannot open a read/write filehandle.

=head1 FUNCTIONS

=head2 get_read_fh(filename)

Open and return a readonly filehandle.  It is assumed the file being opened has been gzipped.

=head2 get_write_fh(filename)

Open and return a write filehandle.  The file being written will be auto-gzipped.

=head1 AUTHOR

Kevin Bosak
