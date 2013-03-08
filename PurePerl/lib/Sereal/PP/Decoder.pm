package Sereal::PP::Decoder;

use 5.008;
use Carp qw/croak/;

our $VERSION = '0.01';

use Exporter 'import';
our @EXPORT_OK = qw(decode_sereal looks_like_sereal);
our %EXPORT_TAGS = (all => \@EXPORT_OK);
# export by default if run from command line
our @EXPORT = ((caller())[1] eq '-e' ? @EXPORT_OK : ());

use Modern::Perl;

use Moo;
use namespace::autoclean;

# for testing purpose
sub SRL_MAGIC_STRING { '=srl' }

sub looks_like_sereal {
    my ($self, $string) = @_;
    say " -- $string";
    defined $string
      or return;
    length $string
      or return;
    my ($magic, $version_type, $header_suffix_size, $rest ) = unpack('a4h2w*a*', $string);
    my $header_suffix = '';
    if ($header_suffix_size > 0) {
        ($header_suffix, $rest) = unpack( 'c'. $header_suffix_size . 'a*', $rest);
    }
    say " -- magic : $magic";
    say " -- version_type : $version_type";
    my ($version, $type) = split //, $version_type;
    say " version $version, type $type";
    say "header_suffix_size : [$header_suffix_size]";
    say "header_suffix : [$header_suffix]";
    say "the rest : $rest";
#    $magic eq SRL_MAGIC_STRING
#      &&

}

1;
