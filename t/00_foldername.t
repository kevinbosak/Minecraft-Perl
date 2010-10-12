#!/usr/bin/perl

use Test::More tests => 3;

BEGIN {use_ok('Minecraft::Util');}

my ($chunk_x, $chunk_z) = (0,0);
my $path;
ok($path = Minecraft::Util::get_chunk_path({chunk_x => $chunk_x, chunk_z => $chunk_z}), "Getting chunk");
is($path, '0/0/c.0.0.dat', "Path for chunk 0,0");

($chunk_x, $chunk_z) = (-13,44);
ok($path = Minecraft::Util::get_chunk_path({chunk_x => $chunk_x, chunk_z => $chunk_z}), "Getting chunk");
is($path, '1f/18/c.-d.18.dat', "Path for chunk -13,44");
