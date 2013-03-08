#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Bin/../lib";
use Sereal::Encoder qw(encode_sereal);
use Sereal::PP::Decoder;


use 5.012_000;
use strict;
use warnings;

use Data::Dumper;
use String::Dump qw( dump_hex dump_bin );

my $e = Sereal::Encoder->new( { snappy_incr => 0, snappy_threshold => 0 });
my $d = Sereal::PP::Decoder->new();

say "plop";
my $s = $e->encode(17);

say Dumper($s);
say sprintf("%0*v2X", " ", $s);
say sprintf("%0*v8b", " ", $s);

my $result = $d->looks_like_sereal($s);

say Dumper($result);
