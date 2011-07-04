#!/usr/bin/perl

use Minecraft::Util;

my $chunk_x = shift;
my $chunk_y = shift;

die "Need X and Y Position" if (!defined $chunk_x || !defined $chunk_y);

print Minecraft::Util::get_chunk_path({x_pos => $chunk_x, y_pos => $chunk_y}) . "\n";
