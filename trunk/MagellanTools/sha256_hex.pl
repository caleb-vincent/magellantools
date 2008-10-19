#!/usr/bin/env perl
use strict;
use warnings;
use Digest::SHA qw( sha256_hex );

foreach my $word ( @ARGV )
{
    my $passHash = sha256_hex( 'test' );

    print $word. " = " . $passHash . "\n";
}

