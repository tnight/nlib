#!e:/perl/bin/perl -w
#===========================================================================
# $Id: viewlib.pl,v 1.2 2003/03/19 06:10:35 terryn Exp $
#
# Enable the users to view the contents of the library.
#
# $Log: viewlib.pl,v $
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

my $LIB_DIR = '/final/lib';
my $FILES_PAGE = '/final/files.html';
my $MENU_PAGE = '/final/menu.html';

sub main();

main();

sub main() {

  # Open the directory containing the library documents.
  my $real_lib_dir = $ENV{'DOCUMENT_ROOT'} . "/" . $LIB_DIR;
  opendir(DIR, "$real_lib_dir") 
    or die "Can't open library directory: \"$!\"";

  # Get a list of the files in the library directory, ignoring files
  # beginning with a dot (".").  Found this in the 'perldoc' manpage.
  my @files = grep { /^[^\.]/ && -f "$real_lib_dir/$_" } readdir(DIR);
  closedir DIR;

  # Sort the list of files.
  my @sorted_files = sort @files;

  # Get the username from our CGI parameters.
  my $cgi = new CGI;
  my $username = $cgi->param('u');
  
  # Build up an HTML listing of the files in the library.
  my $file;
  my $listing;
  my $count = 0;
  foreach $file (@sorted_files) {
    $count = $count + 1;
    $listing .= "<tr><td align=\"center\"><a href=\"/cgi-bin/viewfile.pl$LIB_DIR/${file}?u=${username}\">$file</a></td>";
    $listing .= "<td align=\"center\">";
    $listing .= "<a href=\"/cgi-bin/emailfile.pl?file=${file}&u=${username}\">Send This File via Email</a></td>";
    $listing .= "<td align=\"center\">";
    $listing .= "<a href=\"/cgi-bin/getupdates.pl?file=${file}&u=${username}\">Subscribe to File Updates</a></td></tr>";
  }

  # Show the listing in the browser.
  my $page_name = $ENV{'DOCUMENT_ROOT'} . $FILES_PAGE; 
  open(PAGE, $page_name);
  my @page = <PAGE>;
  close(PAGE);

  # Insert the library file's contents into the page and show it.
  my $line;
  foreach $line (@page) {
    $line =~ s/email\@address.com/$username/;
    $line =~ s/<!-- listing -->/$listing/;
  }
  print "Content-Type: text/html\n\n";
  print @page;
}


