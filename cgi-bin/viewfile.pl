#!e:/perl/bin/perl -w
#===========================================================================
# $Id: viewfile.pl,v 1.1 2003/03/19 02:32:40 terryn Exp $
#
# Enable the users to view the files in the library.
#
# $Log: viewfile.pl,v $
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);

my $LOGIN_PAGE = '/final/login.html';
my $VIEW_PAGE = '/final/viewpage.html';

sub main();

main();

sub main() {
  my $cgi = new CGI;
  my $username = $cgi->param('u');
  my $file = $ENV{'PATH_INFO'};

  if (! $username) {
    # Send them to the "new user signup" page.
    print $cgi->redirect($LOGIN_PAGE);
  }
  else {
    # Record the user's file view in the admin log file.
    open(ADMIN, ">>adminlog.txt") 
      or die "Can't open admin log file: \"$!\"";
    my $log_message = 
      scalar localtime() . " - " . $username . " viewed " . $file . ".\n";
    print ADMIN $log_message;
    close(ADMIN);

    # Get our page that shows them the file.
    my $page_name = $ENV{'DOCUMENT_ROOT'} . $VIEW_PAGE; 
    open(PAGE, $page_name);
    my @page = <PAGE>;
    close(PAGE);

    # Get the contents of the file they want to see.
    my $file_name = $ENV{'DOCUMENT_ROOT'} . $file;
    open(FILE, $file_name);
    my @the_file = <FILE>;
    close(FILE);
    my $file_contents = join('', @the_file);
    
    # Insert the library file's contents into the page and show it.
    my $line;
    foreach $line (@page) {
      $line =~ s/email\@address.com/$username/;
      $line =~ s/<!-- file here -->/$file_contents/;
    }
    print "Content-Type: text/html\n\n";
    print @page;
  }
}


