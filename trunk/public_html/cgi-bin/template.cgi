#!/usr/bin/env perl
use strict;
use warnings;
use HTML::Template;
use CGI::Pretty qw/:standard/;
use CGI::Carp (
    'warningsToBrowser',
    'fatalsToBrowser'
);
print header;
warningsToBrowser(1);
# TEMPLATE DECLARATION
my $login = HTML::Template->new( filename=>'../sdd/login.tpl' );
my $teacher = HTML::Template->new( filename=>'../sdd/teacher.tpl' );

# PARAMETER VARIABLES 
my $login_title = 'BuzzwordBingo!'; # LOGIN PAGE TITLE
my $login_style = '../sdd/default.css'; # LOGIN CSS FILE
my $login_action = 'template.cgi'; # LOGIN FORM ACTION

my $teacher_title = 'BuzzwordBingo![Teacher Interface]'; # TEACHER PAGE TITLE
my $teacher_style = '../sdd/default.css'; # TEACHER CSS FILE
my $teacher_action = 'template.cgi'; # TEACHER FORM ACTIONS

# LOGIC
if( validate_user() )
{ 
    $teacher->param( title=>$teacher_title, style=>$teacher_style, action=>$teacher_action );
    print $teacher->output();
} else
{
    $login->param( title=>$login_title, style=>$login_style, action=>$login_action );
    print $login->output();
}

# USER VALIDATION SUBROUTINE
sub validate_user
{
    if(param( 'login-user' ) == 'test' && param( 'login-password' ) == 'test' ) # FOR DEMO ONLY
    {
        return 1;
    }
}
