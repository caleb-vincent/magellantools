#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Template;
use CGI::Pretty qw/:standard/;
use CGI::Carp (
    'warningsToBrowser',
    'fatalsToBrowser'
);
use Digest::SHA qw/sha256_hex/;
require '../../MagellanTools/database.dat'; #contains database information




print header();
print Dump;
########## NOTES ##########
# 10/09/08 [SPM] - Change GET to POST in the template files( login.tpl and teacher.tpl )
#                  when done testing
#
#
###########################

warningsToBrowser(1);
# TEMPLATE DECLARATION
my $login = HTML::Template->new( filename=>'../sdd/login.tpl' );
my $teacher = HTML::Template->new( filename=>'../sdd/teacher.tpl' );

# PARAMETER VARIABLES 
my $login_title = 'BuzzwordBingo!'; # Login page title
my $login_style = '../sdd/default.css'; # Login css file
my $login_action = 'template.cgi'; # Login form action
my $err_msg = "";

my $teacher_title = 'BuzzwordBingo![Teacher Interface]'; # Teacher page title
my $teacher_style = '../sdd/default.css'; # Teacher style file
my $teacher_action = 'template.cgi'; # Teacher form actions

# LOGIC

my $dbh = db_connect(); #called from database.dat Don't leave here... just an example

if( !param() )
{
	$err_msg = "";
	show_login();
}
elsif ( param( 'page' ) eq 'Login' )
{
	if( validate_user( param( 'login-user'), param( 'login-password' ) ) )
	{
		$teacher->param( title=>$teacher_title, style=>$teacher_style, action=>$teacher_action );
		print $teacher->output();
	} 
	else
	{
		$err_msg = "Invalid username and/or password"; 
		show_login();
	}
}
elsif ( param( 'page' ) eq 'Register' )
{
	if ( param( 'register-password') eq '' )
	{
		$err_msg = "Password must not be blank, Foo\'"; 
		show_login();
	}
	elsif( param( 'register-password') eq param( 'confirm-password' ) )
	{
		my $pass_hash = sha256_hex( param( 'register-password' ) );
		if( add_user( param( 'register-user' ), $pass_hash, param( 'real-name' ) ) )
		{
			$teacher->param( title=>$teacher_title, style=>$teacher_style, action=>$teacher_action );
            print $teacher->output();
		}
		else
		{
            $err_msg = "User already exists, Foo\'"; 
            show_login();
		}
	} 
	else
	{
		$err_msg = "Passwords do not match"; 
		show_login();
	}
}
elsif( param( 'page' ) eq 'Your Games')
{
    #display game page
}

#LOGIN PAGE
sub show_login
{
    $login->param( title=>$login_title, style=>$login_style, action=>$login_action, errmsg=>$err_msg );
    print $login->output();
}
# USER VALIDATION SUBROUTINE
# Pass a username and a password to this function to 
# validate that they exist in our system.
sub validate_user
{
	my $dbh = db_connect(); #called from database.dat
	
	# retrieve function arguments
    my $user = shift;
    my $password = shift;
    
	# get hash of password
	my $pass_hash = sha256_hex( $password );
	
	# prepare a statement to get database row that matches username 
	my $statement = "SELECT * FROM mag_Login WHERE user_name = '$user'";
	
	# store the database row in an array
	my @row_ary = $dbh->selectrow_array( $statement );
	
	db_disconnect( $dbh ); # close database
	
	# if hash of entered password is the same as stored password
	if( $pass_hash eq $row_ary[1] ) 
    {
        return 1;
    } 
	else
    {
        return 0;
    }
}

# CREATE USER ENVIRONMENT
# Makes the user files and directory structure and adds them
# to the database.
sub add_user
{
    my $dbh = db_connect(); #called from database.dat
	# retirieve function arguments
    my $username = shift;
    my $password = shift;
    my $real_name = shift;
	
	# prepare a statement to get database row that matches username 
	my $statement = "SELECT * FROM mag_Login WHERE user_name = '$username'";
	
    # store the database row in an array
	my @row_ary = $dbh->selectrow_array( $statement );
    
	# if we got this user
	if( $row_ary[0] ne "" )
	{
		#! Early Return
		return 0;
	}
    
	# TODO: add check for SQL injection in username
	# TODO: add check for invalid characters ( covers previous  TODO )
    if( $username ne "" && $password ne "" ) #just to avoid warnings, does not actually check
    {
        #create directory and skeleton files
        mkdir( "../sdd/$username" );
        mkdir( "../sdd/$username/games" );
        mkdir( "../sdd/$username/games/bingo" );
        mkdir( "../sdd/$username/games/wordsearch" );
        mkdir( "../sdd/$username/games/crossword" );
        # ADD TO DATABASE
        my $query = "INSERT INTO mag_Login VALUES( '$username',  '$password', '$real_name' )";
        $dbh->do( $query );
		$query = 'CREATE TABLE mag_'.$username.'( game_type char(3) character set ucs2 collate ucs2_bin NOT NULL,
         lecture char( 255 ) character set ucs2 collate ucs2_bin NOT NULL,
         word char( 255 ) character set ucs2 collate ucs2_bin NOT NULL,
         word_num int(6) NOT NULL,
         `key` INT(6) NOT NULL AUTO_INCREMENT PRIMARY KEY )  ENGINE=MyISAM DEFAULT CHARSET=ucs2 collate ucs2_bin
';
        $dbh->do( $query ); 
    }
    db_disconnect( $dbh ); #close database
	
	return 1;
}
