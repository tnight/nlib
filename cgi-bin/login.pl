#!e:/perl/bin/perl -w
#===========================================================================
# $Id: login.pl,v 1.1 2003/03/19 02:32:40 terryn Exp $
#
# Enable the users to login.
#
# $Log: login.pl,v $
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $MENU_SCRIPT = '/cgi-bin/menu.pl';
my $NEW_PWD_PAGE = '/final/newpwd.html';

sub main();

main();

sub main() {
  my $cgi = new CGI;
  my $username = $cgi->param('username');
  my $password = $cgi->param('password');

  if (! $username || ! $password) {
    # Send them to the "new user signup" page.
    print $cgi->redirect($NEW_PWD_PAGE);
  }
  else {
    # Read the password file from disk.
    open(PWD, "pwd.txt") or die "Can't open password file: \"$!\"";
    my @lines = <PWD>;
    close(PWD);

    # Create a data structure containing all valid users.
    my $line;
    my %users;
    my $user;
    my $pass;
    foreach $line (@lines) {
      chomp $line;
      ($user, $pass) = split(/\t/, $line);
      $users{$user} = $pass;
    }

    # Check the login credentials.
    if (exists $users{$username} 
      && $users{$username} eq $password) 
    {
      # Record the user's login in the admin log file.
      open(ADMIN, ">>adminlog.txt") 
        or die "Can't open admin log file: \"$!\"";
      my $log_message = 
        scalar localtime . " - " . $username . " logged in.\n";
      print ADMIN $log_message;
      close(ADMIN);

      # Send them to the menu page.
      print $cgi->redirect("${MENU_SCRIPT}?u=$username");
    }
    else {
      # Send them to the "new user signup" page.
      print $cgi->redirect($NEW_PWD_PAGE);
    }
  }
}
