#!/usr/bin/env perl


##########################################
#                                        #
#               INCLUDES                 #
#                                        #
##########################################

use strict;
use warnings;
use HTML::Template;
use CGI::Pretty qw/:standard/;
use CGI::Carp (
    'warningsToBrowser',
    'fatalsToBrowser'
);
use CGI;
use Digest::SHA qw/sha256_hex/;
use CGI::Session;
require '../../MagellanTools/database.dat';     # contains database information


########## NOTES ###########################
# 10/09/08 [SPM] - Change GET to POST in the template files( login.tpl and teacher.tpl )
#                  when done testing
#
#
############################################


############################################
#                                          #
#              INITIALIZATION              #
#                                          #
############################################

warningsToBrowser( 1 );

# GLOBALS
my $session;                                                # Global session variable
my $upload_base = '../sdd/';                                 # This needs to point to where the user folders are created

# TEMPLATE DECLARATION
my $login = HTML::Template->new( filename=>'../sdd/login.tpl' );
my $teacher = HTML::Template->new( filename=>'../sdd/teacher.tpl' );
my $gamelist = HTML::Template->new( filename=>'../sdd/your_games.tpl' );
my $searchresults = HTML::Template->new( filename=>'../sdd/teachers_games.tpl' );
my $wordsearch = HTML::Template->new( filename=>'../sdd/wordsearch.tpl' );

# PARAMETER VARIABLES
my $err_msg = "";

my $login_title = 'BuzzwordBingo!';                         # Login page title
my $login_style = '../sdd/default.css';                     # Login css file
my $login_action = 'template.cgi';                          # Login form action

my $teacher_title = 'BuzzwordBingo![Teacher Interface]';    # Teacher page title
my $teacher_style = '../sdd/default.css';                   # Teacher style file
my $teacher_action = 'template.cgi';                        # Teacher form actions

my $gamelist_title = 'BuzzwordBingo![Your Games]';          # Game list page title
my $gamelist_style = '../sdd/default.css';                  # Game list style file
my $gamelist_action = 'template.cgi';                       # Game list form actions


##############################################
#                                            #
#                LOGIC                       #
#                                            #
##############################################


if( !param( ) || param( 'page' ) eq 'Home' )
{
    # user has just reached our page
    # show them the login/register modules
    $err_msg = "";
    show_login( );
}
elsif ( param( 'page' ) eq 'Login' )
{
    # user is attempting to login
    if( validate_user( param( 'login-user'), param( 'login-password' ) ) )
    {
        # user logged in successfully
        # bringing them to teacher page
        make_session($session, param( 'login-user' ) );
        show_teacher( );
    }
    else
    {
        # user failed to give proper credentials
        $err_msg = "Invalid username and/or password";
        show_login( );
    }
}
elsif ( param( 'page' ) eq 'Register' )
{
    # user is attempting to register
    if ( param( 'register-password') eq '' )
    {
        # user did not enter a password for registration
        # let them know and return to login
        $err_msg = "Password must not be blank, Foo\'";
        show_login( );
    }
    elsif( param( 'register-password') eq param( 'confirm-password' ) )
    {
        # passwords match
        my $pass_hash = sha256_hex( param( 'register-password' ) );
        if( add_user( param( 'register-user' ), $pass_hash, param( 'real-name' ) ) )
        {
            # user was added successfully
            # bring them to the teacher page
            make_session( $session, param( 'register-user' ) );
            show_teacher( );
        }
        else
        {
            # user is already in our database
            # return them to login and let them know
            $err_msg = "User already exists, Foo\'";
            show_login( );
        }
    }
    else
    {
        # user's password's do not agree
        # change error message and return to login
        $err_msg = "Passwords do not match";
        show_login();
    }
}
elsif( param( 'page' ) eq 'Your Games' )
{
    # display game page
    print header( );
    # Get the session
    get_session( $session );
    show_gamelist();
}
elsif( param( 'page' ) eq 'Find Teacher' )
{
    # display game page
    print header( );
    show_search_results( param( 'teacher-name' ) );
}
elsif( param( 'page' ) eq 'Teacher Page' )
{
    # display teacher page
    print header();
    get_session( $session );
    show_teacher( );
}
elsif( param( 'Page' ) eq 'Add Words')
{
    # user is trying to add new words
    if( !param( 'teacher-upload' )  && param( 'teacher-list' ) )
    {
        # there is no file being uploaded
        
    }
    elsif( param( 'teacher-upload' ) )
    {
        # there is a file to read
    }
    else
    {
        # form is blank
    }
}
elsif( param( 'page' ) eq 'wordsearch' )
{
    print header();
    show_wordsearch( );
}

#########################################
#                                       #
#             SUBROUTINES               #
#                                       #
#                                       #
#########################################

# SHOW GAMES LIST
# Accepts no input
# Displays the game list
sub show_gamelist
{
    # Connect to database
    my $dbh = db_connect( );
    # Get the tables for the current teacher
    my $user = ( $session->param( 'username' ) );
    my $query = "select lecture, game_type from mag_$user";
    my $result = $dbh->prepare( $query );
    $result->execute( );
    # Put games into array reference
    my $curgames = $result->fetchall_arrayref
    (
        {
         lecture   => 1,
         game_type   => 1,
        }
    );
    # Close DB connection
    db_disconnect( $dbh );
    # Load up template
    $gamelist->param( title=>$gamelist_title, style=>$gamelist_style, action=>$gamelist_action, user=>( $session->param( 'username') ), games=>$curgames );
    print $gamelist->output( );
}

# SHOW SEARCH RESULTS
# Accepts no input
# Displays the game list
sub show_search_results()
{
    my $search_term = shift;
    my $dbh = db_connect( );
    # Get the tables for the current teacher
    my $query = "select lecture, game_type from mag_$search_term";
    my $result = $dbh->prepare( $query );
    $result->execute( );
    # Put games into array reference
    my $curgames = $result->fetchall_arrayref
    (
        {
         lecture   => 1,
         game_type   => 1,
        }
    );
    # Close DB connection
    db_disconnect( $dbh );
    # Load up template
    $searchresults->param( title=>$gamelist_title, style=>$gamelist_style, action=>$gamelist_action, user=>( $search_term ), games=>$curgames );
    print $searchresults->output( );
}

# SHOW TEACHER PAGE
# Accepts  no input
# Displays the teacher page
sub show_teacher
{
    $teacher->param( title=>$teacher_title, style=>$teacher_style, action=>$teacher_action, user=>( $session->param( 'username' ) ) );
    print $teacher->output( );
}

# SHOW LOGIN PAGE
# Accepts no input
# Displays the login page
# and prints the header
sub show_login
{
    print header( );
    $login->param( title=>$login_title, style=>$login_style, action=>$login_action, errmsg=>$err_msg );
    print $login->output( );
}

# SHOW WORDSEARCH PAGE
# Displays the word search
sub show_wordsearch
{
    $wordsearch->param( teacher=>'dummy', lecture=>'DUMMY', array=>'DUMMY' );
    print $wordsearch->output( );
}

# USER VALIDATION SUBROUTINE
# Pass a username and a password to this function to
# validate that they exist in our system.
sub validate_user
{
    my $dbh = db_connect( ); #called from database.dat

    # retrieve function arguments
    my $user = shift;
    my $password = shift;

    # get hash of password
    my $pass_hash = sha256_hex( $password );

    # prepare a statement to get database row that matches username
    my $statement = "SELECT * FROM mag_Login WHERE user_name = '$user'";
#   "SELECT * FROM mag_Login WHERE user_name = 'tom' OR 1"; $pass_hash=$row_ary[1];"''";

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
    my $dbh = db_connect( ); #called from database.dat
    # retrieve function arguments
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
         `key` INT(6) NOT NULL AUTO_INCREMENT PRIMARY KEY )  ENGINE=MyISAM DEFAULT CHARSET=ucs2 collate ucs2_bin';
        $dbh->do( $query );
    }
    db_disconnect( $dbh ); #close database

    return 1;
}

# CREATE USER SESSION
# Pass in the global session variable
# and the username to create a new session
sub make_session
{
    $_[0] = new CGI::Session( undef,undef,{ 'Directory'=>"/tmp" } );
    $_[0]->param( 'username',$_[1] );
    $_[0]->expire( '+8h' );
    my $cookie = CGI::cookie( CGISESSID => $session->id );
    print header( -cookie=>$cookie );
}

# GET USER SESSION
# Pass in the global session  variable
# to get the proper session from the user's
# cookies.
sub get_session
{
    my $cookie = CGI::cookie( -name => "session" );
    if ( $cookie )
    {
        CGI::Session->name( $cookie );
    }
    $err_msg = "Invalid Session ID";
    $_[0] = new CGI::Session( "driver:File",$cookie,{ 'Directory'=>"/tmp" } ) or show_login( );
    $err_msg = "";
}
