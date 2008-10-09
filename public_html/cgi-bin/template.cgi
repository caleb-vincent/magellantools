#!/usr/bin/env perl
use strict;
use warnings;
use HTML::Template;
use CGI::Pretty qw/:standard/;
use CGI::Carp (
    'warningsToBrowser',
    'fatalsToBrowser'
);

print header();
########## NOTES ##########
# 10/09/08 [SPM] - Change GET to POST in the template files( login.tpl and teacher.tpl )
#                  when done testing
# Z||H!3h+qwHZ :db pass for sddApp
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

my $teacher_title = 'BuzzwordBingo![Teacher Interface]'; # Teacher page title
my $teacher_style = '../sdd/default.css'; # Teacher style file
my $teacher_action = 'template.cgi'; # Teacher form actions

# LOGIC
if( validate_user( param( 'login-user' ), param( 'login-password' ) ) )
{ 
    $teacher->param( title=>$teacher_title, style=>$teacher_style, action=>$teacher_action );
    print $teacher->output();
} else
{
    $login->param( title=>$login_title, style=>$login_style, action=>$login_action );
    print $login->output();
}

# USER VALIDATION SUBROUTINE
# Pass a username and a password to this function to 
# validate that they exist in our system.
sub validate_user
{
    my $user = shift;
    my $password = shift;
    
    if($user eq 'test' && $password eq 'test' ) # FOR DEMO ONLY
    {
        return 1;
    } else
    {
        return 0;
    }
}

# CREATE USER ENVIRONMENT
# Makes the user files and directory structure and adds them
# to the database.
sub add_user
{
    my $username = shift;
    my $password = shift;
    
    if( $username ne "" && $password ne "" ) #just to avoid warnings, does not actually check
    {
        #create directory and skeleton files
        mkdir( "../sdd/$username" );
        mkdir( "../sdd/$username/games" );
        mkdir( "../sdd/$username/games/bingo" );
        mkdir( "../sdd/$username/games/wordsearch" );
        mkdir( "../sdd/$username/games/crossword" );
        #TODO - ADD TO DATABASE       
    }
}