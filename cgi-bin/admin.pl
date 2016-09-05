#!e:/perl/bin/perl -w
#===========================================================================
# $Id: admin.pl,v 1.1 2003/03/19 02:32:40 terryn Exp $
#
# Enable the administrative user to view log activity.
#
# $Log: admin.pl,v $
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

sub main();

main();

sub main() {

  # Read the admin log file from disk.
  open(LOG, "adminlog.txt") or die "Can't open password file: \"$!\"";
  my @lines = <LOG>;
  close(LOG);
    
  # Show the contents of the admin log file in the browser.
  print "Content-Type: text/html\n\n";
  print "<html><head><title>Administrative Log</title></head>";
  print "<body bgcolor=\"ffffff\">";
  print "<div align=\"center\">";
  print "<h1>Administrative Log</h1>";
  print "<table><tr><td><pre>";
  print @lines;
  print "</pre></td></tr>";
  print "</div>";
  print "</body></html>";
}


