#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;
use Minecraft::Util;

my $items = Minecraft::Util::get_inventory_items();
warn Dumper $items;
