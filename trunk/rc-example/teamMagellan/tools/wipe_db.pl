#!/usr/bin/env perl

require './database.dat';
use strict;
use warnings;

my $dbh = db_connect( );
my $query = "SELECT * FROM mag_Login";
my $ret = $dbh->prepare( $query );
my $ret2;
$ret->execute();
while( my $ref = $ret->fetchrow_hashref( ) )
{
    $query = "DROP TABLE mag_$ref->{'user_name'}";
    my $ret2 = $dbh->do( $query );
    print "Table 'mag_$ref->{'user_name'}' has been dropped.\n";
}
$query = "TRUNCATE TABLE mag_Login";
$ret = $dbh->do( $query );
print "mag_Login has been cleared!\nDatabase is now clean."
