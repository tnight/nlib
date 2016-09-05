#!e:/perl/bin/perl -w
#===========================================================================
# $Id: search.pl,v 1.2 2003/03/19 06:10:35 terryn Exp $
#
# Enable the users to search the library for keywords.
#
# $Log: search.pl,v $
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
my $RESULTS_PAGE = '/final/results.html';
my $SEARCH_PAGE = '/final/search.html';
my $SEARCH_SCRIPT = '/cgi-bin/search.pl';

sub main();
sub error_page ($$);

main();

sub main() {
  my $cgi = new CGI;
  my $page = $cgi->param('page');
  my $username = $cgi->param('u');
  
  if (! $page || $page == 1) {
    # Show them the search page, customized for their own username so we
    # can track their activities.
    my $page_name = $ENV{'DOCUMENT_ROOT'} . $SEARCH_PAGE; 
    open(PAGE, $page_name);
    my @page = <PAGE>;
    close(PAGE);

    my $line;
    foreach $line (@page) {
      $line =~ s/email\@address.com/$username/;
    }
    print "Content-Type: text/html\n\n";
    print @page;
  }
  else {
    # Search the library and show them the results.
    my $keywords = $cgi->param('keywords');
  
    if (! $keywords) {
      # Send them an error message, allowing them to go back the search page.
      my $error = "You did not enter any keywords.";
      error_page($error, $username);
    }
    elsif (length($keywords) < 3) {
      # Send them an error message, allowing them to go back the search page.
      my $error = "Keywords must be at least three characters in length.";
      error_page($error, $username);
    }
    else {
      # Make sure the keywords don't have "special" characters.
      $keywords =~ s/[^0-9a-zA-Z\s]//g;
  
      # Split the "keywords" value up into individual words
      my @words = split(/\s+/, $keywords);
      
      # Turn the words into an "or"-style regular expression.
      my $expr = join("|", @words);
      
      # Use the grep command to find the keywords.
      my $real_lib_dir = $ENV{'DOCUMENT_ROOT'} . $LIB_DIR;
      my $command = "egrep -in \"($expr)\" \"${real_lib_dir}\"/*";
  
      my $matches = `$command`;
  
      if (! $matches) {
        $matches = "No matches found.";
      }
      else {
        $matches =~ s/$real_lib_dir\///gm;
        $matches =~ s/:/: /gs;
        $matches =~ s/: (\d+):/(line $1):/gm;
        $matches =~ s/^([\.\s\w]+?)\(/<a href=\"\/cgi-bin\/viewfile.pl${LIB_DIR}\/${1}?u=${username}\">${1}<\/a>\(/gm;
      }
      
      # Show the search results page in the browser.
      my $page_name = $ENV{'DOCUMENT_ROOT'} . $RESULTS_PAGE; 
      open(PAGE, $page_name);
      my @page = <PAGE>;
      close(PAGE);
  
      my $line;
      foreach $line (@page) {
        $line =~ s/email\@address.com/$username/;
        $line =~ s/<!-- matches -->/$matches/;
      }
      print "Content-Type: text/html\n\n";
      print @page;
    }
  }
}

sub error_page ($$) {
  my $error = shift;
  my $username = shift;

  print "Content-Type: text/html\n\n";
  print "<html><head><title>Search Error</title></head>";
  print "<body bgcolor=\"ffffff\">";
  print "<h1>Search Error</h1>";
  print "<p>$error</p>";
  print "<p>Please <a href=\"${SEARCH_SCRIPT}?u=${username}\">try again</a>.</p>";
  print "</body></html>";
}
