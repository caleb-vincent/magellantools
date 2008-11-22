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
use File::Basename;
require '../../MagellanTools/database.dat';     # contains database information
require './wordsearch.pm';                      #contains the wordsearch class


########## NOTES ###########################
# 10/09/08 [SPM] - Change GET to POST in the template files
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
my $session = undef;                                                # Global session variable

# TEMPLATE DECLARATION
my $login = HTML::Template->new( filename=>'../sdd/login.tpl' );
my $teacher = HTML::Template->new( filename=>'../sdd/teacher.tpl' );
my $gamelist = HTML::Template->new( filename=>'../sdd/teacher_games.tpl' );
my $searchresults = HTML::Template->new( filename=>'../sdd/student_games.tpl' );
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


if( !param( ) || param( 'page' ) eq 'Home')
{
    # user has just reached our page
    # show them the login/register modules
    get_session( $session );
    if(defined($session))
    {
        $err_msg = "";
        print header();
        show_teacher();
    }
}
elsif ( param( 'page' ) eq 'Home' && $session )
{
    $err_msg = "";
    print header( );
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
        $err_msg = "";
        show_teacher( );
    }
    else
    {
        # user failed to give proper credentials
        $err_msg = "Invalid username and/or password";
        print header( );
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
        print header( );
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
            $err_msg = "";
            show_teacher( );
        }
        else
        {
            # user is already in our database
            # return them to login and let them know
            $err_msg = "User already exists, Foo\'";
            print header( );
            show_login( );
        }
    }
    else
    {
        # user's password's do not agree
        # change error message and return to login
        $err_msg = "Passwords do not match";
        print header( );
        show_login();
    }
}
elsif( param( 'page' ) eq 'Your Games' )
{
    # display game page
    print header( );
    # Get the session
    get_session( $session );
    $err_msg = "";
    show_gamelist();
}
elsif( param( 'page' ) eq 'Find Teacher' )
{
    # display game page
    print header( );
    $err_msg = "";
    show_search_results( param( 'teacher-name' ) );
}
elsif( param( 'page' ) eq 'Teacher Page' )
{
    # display teacher page
    print header();
    get_session( $session );
    $err_msg = "";
    show_teacher( );
}
elsif( param( 'page' ) eq 'Add Words')
{
    # user is trying to add new words
    get_session( $session );
    print header( );
    if( !param( 'teacherupload' )  && param( 'teacher-list' ) && param( 'game-type' ) )
    {
        # there is no file being uploaded
        my @temp = split( '\r\n',param( 'teacher-list' ) );
        if(!defined(@temp))
        {
            @temp = split( '\n',param( 'teacher-list' ) );
        }
        chomp(@temp);
        parse_words( \@temp, param( 'lecture-name' ), $session->param('username'), param( 'game-type' ) );
        show_teacher( );
    }
    elsif( param( 'teacherupload' ) && !param('teacher-list') && param( 'game-type' ) )
    {
        # there is a file to read
        my $teacherupload = param('teacherupload');
        chomp( my @temp = <$teacherupload> );
        foreach( @temp )
        {
            $_ =~ s/^(.*)\r$/$1$2/g
        }
        parse_words( \@temp, param( 'lecture-name' ), $session->param('username'), param( 'game-type' ) );
        show_teacher( );
    }
    else
    {
        # form is blank
        $err_msg = "Please fill in the appropriate information, Foo\'";
        show_teacher( );
    }
}
elsif( param( 'page' ) eq 'wordsearch' || param( 'page' ) eq 'WOR' )
{
    print header( );
    show_wordsearch( );
}
elsif( param( 'page' ) eq 'Logout' )
{
    close_session( $session );
    $err_msg = 'You have logged out, Foo\'';
    show_login();
}
elsif( param( 'page' ) eq 'Delete' )
{
print header( );
  # delete word list
  if( param( 'delete' ) )
  {
    remove_game( param( 'delete' ) )
  }
  get_session( $session );
  show_gamelist( );
}


#########################################
#                                       #
#             SUBROUTINES               #
#                                       #
#########################################


# REMOVE GAME
# accepts a 'link' string
sub remove_game
{
    $_[0] =~ m/(.*)_-_(.*)/;
    my $lecture = $1;
    get_session( $session );
    my $user = $session->param( 'username' );
    my $type = $2;
    #die($lecture);
    my $query = "DELETE FROM mag_$user WHERE lecture = '$lecture' AND game_type = '$type'";
    my $dbh = db_connect();
    $dbh->do( $query );
}

# CLOSE SESSION
# Accepts global session
# Closes current session
sub close_session
{
    # beware the session! it is evil!
    get_session( $_[0] );
    $_[0]->clear();
    my $cookie = CGI::cookie( -name=>'CGISESSID', -value=> 0, -expires=>'-1h' );
    print header( -cookie=>$cookie );

}

# PARSE WORDS
# Accepts array reference, lecture, username, gametype
# Adds words to database
sub parse_words
{
    # parse words
    my @lines = @{$_[0]};
    my $lecture = $_[1];
    my $user = $_[2];
    my $gametype = $_[3];
    # add to database
    my $query = "SELECT * FROM mag_".$user." WHERE lecture = '".$lecture."'";
    my $dbh = db_connect( );
    my $ret = $dbh->prepare( $query );
    $ret->execute( );
    my $count = $ret->rows;
    for(my $i = 0; $i <= scalar( @lines ); $i++ )
    {
        # $lines[$i] =~ s#'##g; # this is commented out for beta because it slows down the add word process exponentially. We are currently looking for a workaround.
        if($lines[$i] ne "")
        {
            $query = "INSERT INTO mag_".$user." VALUES( '".$gametype."','".$lecture."','".$lines[$i]."','".$count."','template.cgi?lecture=$lecture&user=$user&page=$gametype','' )";
            $ret = $dbh->prepare( $query );
            $ret->execute();
            $count++;
        }
    }

    $err_msg = "Added ".($#lines+1)." words (unless the line was blank) to lecture: $lecture, Foo\'";
    db_disconnect( $dbh );
}

# SHOW GAMES LIST
# Accepts no input
# Displays the game list
sub show_gamelist
{
    # Connect to database
    my $dbh = db_connect( );
    # Get the tables for the current teacher
    my $user = ( $session->param( 'username' ) );
    my $query = "SELECT DISTINCT lecture, game_type, link FROM mag_$user";
    my $result = $dbh->prepare( $query );
    $result->execute( );
    # Put games into array reference
    my $curgames = $result->fetchall_arrayref
    (
        {
         lecture    => 1,
         game_type  => 1,
         link       => 1,
        }
    );
    # Close DB connection
    db_disconnect( $dbh );
    # Load up template
    $gamelist->param( title=>$gamelist_title, style=>$gamelist_style, action=>$gamelist_action, user=>( $session->param( 'username') ), games=>$curgames, errmsg=>$err_msg );
    print $gamelist->output( );
}

# SHOW SEARCH RESULTS
# Accepts no input
# Displays the game list
sub show_search_results
{
    my $search_term = shift;
    $search_term =~ s#'##g;
    my $dbh = db_connect( );
    # Get the tables for the current teacher
    my $query = "SELECT user_name FROM mag_Login WHERE UPPER(user_name) LIKE UPPER('%$search_term%')";
    my $result = $dbh->prepare( $query );
    $result->execute( );
    my @names;
    my $temp;
    # make it a nice data scructure  an array ;) 
    while( $temp = $result->fetchrow_hashref( ) )
    {
        push(@names,$temp->{'user_name'});
    }
    # if we ain't got nothin'
    if($result->rows <= 0)
    {
        db_disconnect( $dbh );
        my @filler;
        $searchresults->param( title=>$gamelist_title, style=>$gamelist_style, action=>$gamelist_action, user=>( $search_term ), games=>\@filler, errmsg=>$err_msg );
        print $searchresults->output( );
        return;
    }
    # otherwise, display it all
    my @allgames;
    foreach( @names )
    {
        $query = "SELECT DISTINCT lecture, game_type, link FROM mag_$_";
        $result = $dbh->prepare( $query );
        $result->execute( );
        # Put games into array reference
        while( $temp = $result->fetchrow_hashref( ) )
        {
            push( @allgames, $temp );
        }
    }
    # Close DB connection
    db_disconnect( $dbh );
    # Load up template
    $searchresults->param( title=>$gamelist_title, style=>$gamelist_style, action=>$gamelist_action, user=>( $search_term ), games=>\@allgames, errmsg=>$err_msg );
    print $searchresults->output( );
}

# SHOW TEACHER PAGE
# Accepts  no input
# Displays the teacher page
sub show_teacher
{
    $teacher->param( title=>$teacher_title, style=>$teacher_style, action=>$teacher_action, user=>( $session->param( 'username' ) ), errmsg=>$err_msg );
    print $teacher->output( );
}

# SHOW LOGIN PAGE
# Accepts no input
# Displays the login page
# and prints the header
sub show_login
{
    $login->param( title=>$login_title, style=>$login_style, action=>$login_action, errmsg=>$err_msg );
    print $login->output( );
    # some clean up 
    # NOTE: this is after the print so the user doesn't notice
    if ( opendir my $dh, '../sdd/temp' )
    {
        #get the current time
        my @time = localtime;
        # get an array of the files in the directory
        my @files = readdir $dh;
        # an array for the files to be deleted to be stored in
        my @delete_files;
        # ofr every file in the directory
        foreach my $file ( @files )
        {
            # if it matches the day
            if( $file =~ m/(.*)?\-(\d{1,3})(.*)?/ )
            {
                # if it's more than 2 days
                if( $time[7] - $2 > 2 || $2 - $time[7] <= -353 )
                {
                    # push it onto the delete list
                    push( @delete_files, "../sdd/temp/$file" );
                }
            }
        }
        # delete everything on the delete list
        unlink @delete_files;
        # close the directory
        closedir $dh;
    }
    
}

# SHOW WORDSEARCH PAGE
# Displays the word search
sub show_wordsearch
{

    my $dbh = db_connect( );
    # Get the tables for the current teacher\
    my $user = param( 'user' );
    my $lecture = param( 'lecture' );
    # Put games into array reference
    my @curgames = @{ $dbh->selectall_arrayref( "SELECT word FROM mag_$user WHERE lecture = '$lecture' AND game_type = 'WOR'" ) };
    my @dumb_words;
    foreach my $row ( @curgames  )
    {
        push( @dumb_words, ${ $row}[0] );
    }
    # Close DB connection
    db_disconnect( $dbh );

    #create a new word search object
    my $wordsearch_object = Wordsearch->new();
    # initialize and fill it.
    $wordsearch_object->create_wordsearch( @dumb_words );
    # prepare the wordsearch to be sent to ethe template
    my $flattened_chars = join( '","', @{ $wordsearch_object->get_char_array() } );
    my $flattened_words = join( ',', @{ $wordsearch_object->get_word_array() } );
    my $flattened_lengths = join( '","', @{ $wordsearch_object->get_length_array() } );
    my $word_list = join( '","', @{ $wordsearch_object->get_word_list() } );
    #grab the time
    my @time = localtime;
    #time stamp format is sec-min-hour-yday
    my $time_stamp = "$time[0]-$time[1]-$time[2]-$time[7]";
    #this is where a temporary copy of the page is stored for printing
    my $file_name = "$user-$lecture-$time_stamp.html";
    #parse the tamplate, and insert correct values
    $wordsearch->param( teacher=>$user, lecture=>$lecture, char_array=>$flattened_chars, word_array=>$flattened_words, length_array=>$flattened_lengths, style=>$login_style, word_list=>$word_list, file=>"../sdd/temp/$file_name" );
    print $wordsearch->output( );
    # after it has been sent to the user ( don't waste the users time) 
    # create the template again, but with the "print" template used
    $wordsearch->param( teacher=>$user, lecture=>$lecture, char_array=>$flattened_chars, word_array=>$flattened_words, length_array=>$flattened_lengths, style=>"../$login_style", word_list=>$word_list, print=>"true" );
    #make a directory for the temp files (unless it exists)
    mkdir '../sdd/temp';
    #open the filename in the temp directory for writingto
    open my $fh, '>', "../sdd/temp/$file_name";
    print $fh $wordsearch->output( );
    #close the file
    close $fh;
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
        # Early Return
        return 0;
    }

    # TODO: add check for SQL injection in username
    # TODO: add check for invalid characters ( covers previous  TODO )
    if( $username ne "" && $password ne "" ) #just to avoid warnings, does not actually check
    {
        # ADD TO DATABASE
        my $query = "INSERT INTO mag_Login VALUES( '$username',  '$password', '$real_name' )";
        $dbh->do( $query );
        $query = 'CREATE TABLE mag_'.$username.'( game_type char(3) character set ucs2 collate ucs2_bin NOT NULL,
         lecture char( 255 ) character set ucs2 collate ucs2_bin NOT NULL,
         word char( 255 ) character set ucs2 collate ucs2_bin NOT NULL,
         word_num int(6) NOT NULL,
         link char( 255 ) character set ucs2 collate ucs2_bin NOT NULL,
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
    # CGI session magic happens here
    my $cookie = CGI::cookie( -name => "CGISESSID" );
    if ( $cookie )
    {
        CGI::Session->name( $cookie );
        $_[0] = new CGI::Session( "driver:File",$cookie,{ 'Directory'=>"/tmp" } );
    } else
    {
        if( param( 'page' ) eq 'Home' )
        {
            $err_msg = "";
        } else
        {
            $err_msg = "Invalid Session ID";
        }
        $session = undef;
        print header( );
        show_login( );
    }
}
