#!e:/perl/bin/perl -w
#===========================================================================
# $Id: logout.pl,v 1.2 2003/03/19 02:40:35 terryn Exp $
#
# Enable the users to logout.
#
# $Log: logout.pl,v $
# Revision 1.2  2003/03/19 02:40:35  terryn
# Changes for rename of index.html to login.html.
#
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $LOGIN_PAGE = '/final/login.html';

sub main();

main();

sub main() {
  my $cgi = new CGI;
  my $username = $cgi->param('u');

  if ($username) {
      # Record the user's logout in the admin log file.
      open(ADMIN, ">>adminlog.txt") 
        or die "Can't open admin log file: \"$!\"";
      my $log_message = 
        scalar localtime() . " - " . $username . " logged out.\n";
      print ADMIN $log_message;
      close(ADMIN);
  }

  # Send them to the login page.
  print $cgi->redirect($LOGIN_PAGE);
}
