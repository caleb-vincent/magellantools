#!/usr/bin/env perl
use strict;
use warnings;

require '../../MagellanTools/database.dat';     # contains database information

# PARSE WORDS
# Accepts array reference, lecture, username, gametype
# Adds words to database
# parse words

my $lecture = shift(@ARGV);
my $user = shift(@ARGV);
my $gametype = shift(@ARGV);
my $options = shift(@ARGV);
my @lines = @ARGV;

# add to database
my $query = "SELECT * FROM mag_".$user." WHERE lecture = '".$lecture."'";
my $dbh = db_connect( );
my $ret = $dbh->prepare( $query );
$ret->execute( );
my $count = $ret->rows;
for(my $i = 0; $i < scalar( @lines ); $i++ )
{
	$lines[$i] =~ s#'##g; # this is commented out for beta because it slows down the add word process exponentially. We are currently looking for a workaround.
	if( $lines[$i] ne "" )
	{
		$query = "INSERT INTO mag_".$user." VALUES( '".$gametype."','".$lecture."','".$lines[$i]."','".$count."','template.cgi?lecture=$lecture&user=$user&page=$gametype','".$options."','' )";
		$ret = $dbh->prepare( $query );
		$ret->execute();
		$count++;
	}
}


db_disconnect( $dbh );
