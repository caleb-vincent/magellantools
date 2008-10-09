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
my $login = HTML::Template->new( filename=>'../sdd/login.tpl');

# PARAMETER VARIABLES 
my $login_title = 'BuzzwordBingo!'; # LOGIN PAGE TITLE
my $login_style = '../sdd/default.css'; # LOGIN CSS FILE
my $login_action = 'template.cgi'; # LOGIN FORM ACTION


# LOGIC
if(validate_user())
{
 
 print $teacher->output();
} else
{
 $login->param(title=>$login_title, style=>$login_style, action=>$login_action);
 print $login->output();
}

# USER VALIDATION SUBROUTINE
sub validate_user
{
 return true; # FOR DEMO ONLY
}

#There, I committed something.