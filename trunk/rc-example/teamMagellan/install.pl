#!/usr/bin/env perl

BEGIN {
    my $homedir = ( getpwuid($>) )[7];
    my @user_include;
    foreach my $path (@INC) {
        if ( -d $homedir . '/perl' . $path ) {
            push @user_include, $homedir . '/perl' . $path;
        }
    }
    unshift @INC, @user_include;
}


#Check that user has all these modules (needed for the app)
use strict;
use warnings;
use File::Copy;

# Check for modules

my $check = "0";

# Modules to check
my @modCheck = qw(
DBI
HTML::Template
CGI::Pretty
CGI::Carp
CGI
Digest::SHA
CGI::Session
File::Basename
List::Util
Math::Random::MT::Perl
);

my $die = 0;
for (@modCheck)
{
    if (installed("$_"))
    {
        print "$_ installed (version ",$check,")\n"
    }
     else
    {
        print "$_ NOT installed.\n Please install it from CPAN and run this script again.\n\n";
        $die = 1;
    }
}

if($die == 1)
{
    exit();
}

print "Creating directories...\n";
#make needed directories
mkdir( '../sdd' ) or die( "Unable to create directory 'sdd' in public_html.\nReason:$!\n" );
mkdir( '../sdd/images' ) or die( "Unable to create directory 'images' in sdd.\nReason:$!\n" );
mkdir( '../../MagellanTools' ) or die( "Unable to create directory 'MagellanTools' one level up from your public_html.\nReason:$!\n" );

print "Moving files...\n";
#copy files over
copy( './server/bingo.tpl','../sdd/bingo.tpl' ) or die( "Unable to copy file 'bingo.tpl'.\nReason:$!\n" );
copy( './server/default.css','../sdd/default.css' ) or die( "Unable to copy file 'default.css'.\nReason:$!\n" );
copy( './server/index.html','../sdd/index.html' ) or die( "Unable to copy file 'index.html'.\nReason:$!\n" );
copy( './server/login.tpl','../sdd/login.tpl' ) or die( "Unable to copy file 'login.tpl'.\nReason:$!\n" );
copy( './server/student_games.tpl','../sdd/student_games.tpl' ) or die( "Unable to copy file 'student_games.tpl'.\nReason:$!\n" );
copy( './server/teacher.tpl','../sdd/teacher.tpl' ) or die( "Unable to copy file 'teacher.tpl'.\nReason:$!\n" );
copy( './server/teacher_games.tpl','../sdd/teacher_games.tpl' ) or die( "Unable to copy file 'teacher.tpl'.\nReason:$!\n" );
copy( './server/wordsearch.tpl','../sdd/wordsearch.tpl' ) or die( "Unable to copy file 'wordsearch.tpl'.\nReason:$!\n" );
copy( './server/template.cgi','../cgi-bin/template.cgi' ) or die( "Unable to copy file 'template.cgi'.\nReason:$!\n" );
copy( './server/wordsearch.pm','../cgi-bin/wordsearch.pm' ) or die( "Unable to copy file 'wordsearch.pm'.\nReason:$!\n" );
copy( './server/images/etoolslogo.png','../sdd/images/etoolslogo.png' ) or die( "Unable to copy file 'etoolslogo.png'.\nReason:$!\n" );
copy( './server/images/mtoolslogo.png','../sdd/images/mtoolslogo.png' ) or die( "Unable to copy file 'mtoolslogo.png'.\nReason:$!\n" );
copy( './server/images/SiteIcon.ico','../sdd/images/SiteIcon.ico' ) or die( "Unable to copy file 'SiteIcon.ico'.\nReason:$!\n" );
copy( './tools/login.sql','../../MagellanTools/login.sql' ) or die( "Unable to copy file 'login.sql'.\nReason:$!\n" );
copy( './tools/sha256_hex.pl','../../MagellanTools/sha256_hex.pl' ) or die( "Unable to copy file 'sha256_hex.pl'.\nReason:$!\n" );
copy( './tools/wipe_db.pl','../../MagellanTools/wipe_db.pl' ) or die( "Unable to copy file 'wipe_db.pl'.\nReason:$!\n" );
copy( './tools/parse_words.pl','../../MagellanTools/parse_words.pl' ) or die( "Unable to copy file 'parse_words.pl'.\nReason:$!\n" );


print "Setting permissions...\n\n";
#set permissions
system 'chmod 0755 ../cgi-bin/template.cgi';
system 'chmod 0664 ../cgi-bin/wordsearch.pm';

print "Please enter the username you have created for this application's database access: ";
chomp( my $name = <STDIN> );
print "Please enter the password for this user: ";
chomp( my $pass = <STDIN> );
print "Please enter the database for this application: ";
chomp( my $db = <STDIN> );

print "\nGenerating database.dat file...\n";
#make database file
open my $outfh, '>', '../../MagellanTools/database.dat' or die( "Unable to create file 'database.dat'.\nReason:$!\n" );
print $outfh "require DBI;\nuse strict;\nuse warnings;\n#DATABASE VARIABLES\n";
print $outfh 'my $db = \''.$db.'\';'."\n";
print $outfh 'my $db_user = \''.$name.'\';'."\n";
print $outfh 'my $db_pass = \''.$pass.'\';'."\n";
print $outfh
'#COMMON DATABASE FUNCTIONS
sub db_connect
{
    return DBI->connect("DBI:mysql:database=$db;host=localhost", $db_user, $db_pass, {\'RaiseError\' => 1});
}
sub db_disconnect
{
    $_[0]->disconnect();
}
';
close $outfh or die( "Unable to close file 'database.dat'.\nReason:$!\n" );

print "Creating login table...\n";
#my @args = ( "mysql", "-u $name", "-p $pass", "-D $db", "<", "./tools/login.sql" );
#    ( system( @args ) == 0 ) or die "Unable to execute mysql command. Debug: $?\n";

require '../../MagellanTools/database.dat';
my $dbh = db_connect();

my $query = "CREATE TABLE IF NOT EXISTS `mag_Login` (
  `user_name` char(16) character set ucs2 collate ucs2_bin NOT NULL,
  `password` char(64) character set ucs2 collate ucs2_bin NOT NULL,
  `real_name` varchar(32) character set ucs2 collate ucs2_bin NOT NULL,
  PRIMARY KEY  (`user_name`)
) ENGINE=MyISAM DEFAULT CHARSET=ucs2 collate ucs2_bin";

my $ret = $dbh->prepare( $query );
$ret->execute( ) or die( "Unable to create table 'mag_Login'.\nReason: $!\n" );

db_disconnect( $dbh );

print "\nMagellan Tools Installed!\n";
sub installed
  {

    my $module = $_;

    # Try to use/load the Perl module
    eval "use $module";

    # Check eval response
    if ($@)
      {
        # Eval failed, so not installed
        $check = 0;
      }
     else
      {
        # Module is installed (reset module version to '1')
    $check = 1;

        my $version = 0;
    # Try to retrieve version number
        eval "\$version = \$$module\::VERSION";

    # Set version number if no problem occured
        $check = $version if (!$@);
      }

    # Return version number
    return $check;
}
