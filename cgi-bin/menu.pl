#!e:/perl/bin/perl -w
#===========================================================================
# $Id: menu.pl,v 1.1 2003/03/19 02:32:40 terryn Exp $
#
# Enable the users to view the main menu.
#
# $Log: menu.pl,v $
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $MENU_PAGE = '/final/menu.html';
my $LOGIN_PAGE = '/final/login.html';

sub main();

main();

sub main() {
  my $cgi = new CGI;
  my $username = $cgi->param('u');

  if (! $username) {
    # Send them to the login page.
    print $cgi->redirect($LOGIN_PAGE);
  }
  else {
    # Read the password file from disk.
    open(PWD, "pwd.txt") or die "Can't open password file: \"$!\"";
    my @lines = <PWD>;
    close(PWD);

    # Find out if they are an administrative user.
    my $line;
    my $user;
    my $pass;
    my $fname;
    my $lname;
    my $admin;
    my $user_is_admin = 'false';
    foreach $line (@lines) {
      chomp $line;
      ($user, $pass, $fname, $lname, $admin) = split(/\t/, $line);
      if ($user eq $username && $admin eq 'admin') {
        $user_is_admin = 'true';
      }
    }

    # Send them to the menu page, customized for their own username so we
    # can track their activities.
    my $page_name = $ENV{'DOCUMENT_ROOT'} . $MENU_PAGE; 
    open(PAGE, $page_name);
    my @page = <PAGE>;
    close(PAGE);

    # If they are an admin, show them the administrative option.
    my $admin_option;
    if ($user_is_admin eq 'true') {
      $admin_option = "<li>View the <a href=\"/cgi-bin/admin.pl?\">Activity Log</a>.</li>";
    }
    else {
      $admin_option = '';
    }
    
    foreach $line (@page) {
      $line =~ s/email\@address.com/$username/;
      $line =~ s/<!-- admin option here -->/$admin_option/;
    }
    print "Content-Type: text/html\n\n";
    print @page;
  }
}
