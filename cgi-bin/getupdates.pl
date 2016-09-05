#!e:/perl/bin/perl -w
#===========================================================================
# $Id: getupdates.pl,v 1.2 2003/03/19 06:10:35 terryn Exp $
#
# Enable the users to get email when the library files are updated.
#
# $Log: getupdates.pl,v $
# Revision 1.2  2003/03/19 06:10:35  terryn
# Final changes to get working system on localhost.  Next step is
# to upload to Linus and tweak pathing/permissions/etc.
#
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $UPDATE_CONFIRM_PAGE = '/final/updateconfirm.html';
my $VIEW_SCRIPT = '/cgi-bin/viewlib.pl';

sub main();

main();

sub main() {
  my $cgi = new CGI;
  my $file = $cgi->param('file');
  my $username = $cgi->param('u');
  
  # Subscribe the user to updates for the selected file.
  my $line = join("\t", $username, $file);
  open(UPDATES, ">>updates.txt") or die "Can't open update file: \"$!\"";
  print UPDATES $line, "\n";
  close(UPDATES);

  # Show a confirmation message in the browser.
  my $page_name = $ENV{'DOCUMENT_ROOT'} . $UPDATE_CONFIRM_PAGE; 
  open(PAGE, $page_name);
  my @page = <PAGE>;
  close(PAGE);

  my $line;
  foreach $line (@page) {
    $line =~ s/email\@address.com/$username/;
    $line =~ s/\*file\*/$file/;
  }
  print "Content-Type: text/html\n\n";
  print @page;
}
