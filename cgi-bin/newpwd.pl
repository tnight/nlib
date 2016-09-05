#!e:/perl/bin/perl -w
#===========================================================================
# $Id: newpwd.pl,v 1.1 2003/03/19 02:32:40 terryn Exp $
#
# Enable a new user to sign up.
#
# $Log: newpwd.pl,v $
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
sub error_page($);

main();

sub main() {
  my $cgi = new CGI;
  my $username = $cgi->param('username');
  my $password1 = $cgi->param('password1');
  my $password2 = $cgi->param('password2');
  my $fname = $cgi->param('fname');
  my $lname = $cgi->param('lname');
  my $admin = 'notadmin';

  if (! $username || ! $password1 || ! $password2
      || ! $fname || ! $lname)
  {
    # Send them an error message, allowing them to go back the "new
    # user signup" page.
    my $error = "You did not complete all of the required fields.";
    error_page($error);
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

    # Check whether this user is already in the password file.
    if (exists $users{$username}) {
      my $error =
	"User $username already exists. You must choose a different username.";
      error_page($error);
    }
    elsif ($password1 ne $password2) {
      my $error =
	"The two passwords you typed do not match.";
      error_page($error);
    }
    else {
      # Add them to the password file.
      push(@lines, join("\t", $username, $password1, $fname, $lname, $admin));
      open(PWD, ">pwd.txt") or die "Can't open password file: \"$!\"";
      foreach $line (@lines) {
        chomp $line;
        print PWD $line, "\n";
      }
      close(PWD);

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
  }
}

sub error_page ($) {
  my $error = shift;

  print "Content-Type: text/html\n\n";
  print "<html><head><title>Sign-Up Error</title></head>";
  print "<body bgcolor=\"ffffff\">";
  print "<h1>Sign-Up Error</h1>";
  print "<p>$error</p>";
  print "<p>Please <a href=\"$NEW_PWD_PAGE\">try again</a>.</p>";
  print "</body></html>";
}
