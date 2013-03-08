package Sereal::PP::Decoder;

use 5.008;
use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.01';

use Exporter 'import';
our @EXPORT_OK = qw(decode_sereal looks_like_sereal);
our %EXPORT_TAGS = (all => \@EXPORT_OK);
# export by default if run from command line
our @EXPORT = ((caller())[1] eq '-e' ? @EXPORT_OK : ());

# for testing purpose
sub SRL_MAGIC_STRING { '=srl' }
use String::Dump qw( dump_hex dump_bin );

use 5.012_000;

sub new {
    my ($class) = @_;
    bless {}, $class;
}

my $indent = 0;
sub p($) { say( ('  ' x $indent) . $_[0]) }

sub dd ($$) {
    my ($s, $v) = @_;
    p "$s (" . length($v) . "): [$v] | " . sprintf("%0*v2X", " ", $v) . ' | ' . sprintf("%0*v8b", " ", $v);
}

sub looks_like_sereal {
    my ($self, $string) = @_;
    say " -- $string";
    defined $string
      or return;
    length $string
      or return;
    my ($magic, $version_type, $header_suffix_size, $data ) = unpack('a4Cwa*', $string);
    my $header_suffix = bytes::substr($data, 0, $header_suffix_size, '');
    say " -- magic: $magic";
    say " -- version_type: $version_type";
    my $version = ($version_type & 15);
    say " -- version: $version";
    my $type = $version_type >> 4;
    say " -- type: $type";
    say " -- header_suffix_size : [$header_suffix_size]";
    say " -- header_suffix : [$header_suffix]";

    dd data => $data;

    my $result = process_data(\$data, 0);
    return $result;

}

sub process_data {
    my ($dataref, $pos) = @_;
    my $length = bytes::length($$dataref);
    p "processing data from $pos"; 
    $indent++;
    $pos < $length
      or croak 'malformed data, tried to access out of bound data';
    p "* position: $pos";

    # extract the tag
    my $o = vec($$dataref, $pos, 8);

    # handle and remove track flag
    my $track_flag = $o & 0b10000000;
    p "  track_flag: $track_flag";
    $o = $o & 0b01111111;

    my $high_4b = $o & 0b11110000;
    say " -> " . $high_4b;

   
    if ($high_4b == 0) {
        # POS_0 -> POS_15, small pos integer
        p " - octet $pos is a small pos integer";
        return $o;
    }

    if ($high_4b == 0b00010000) {
        # NEG_16 -> NEG_16, small pos integer
        my $low_4b = $o & 0b00001111;
        p " - octet $pos is a small neg integer";
        return $o-32;
    }

    if ($o == 0b00100000) {
        # VARINT
        $pos++;
        #       skip before position)
        my (undef, $v) = unpack( 'a' . $pos . 'w', $$dataref);
        return $v;
    }

    if ($o == 0b00100001) {
        # ZIGZAG-VARINT
        # What the hell is that ?a
        return;
    }

    if ($o == 0b00100001) {
        # FLOAT
        # What the hell is that ?a
        my (undef, $v) = unpack( 'a' . $pos . 'f', $$dataref);
        return;
    }

    
}

#    $magic eq SRL_MAGIC_STRING
#      &&




1;
