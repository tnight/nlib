#!e:/perl/bin/perl -w
#===========================================================================
# $Id: emailfile.pl,v 1.2 2003/03/19 06:10:35 terryn Exp $
#
# Enable the users to email the library files.
#
# $Log: emailfile.pl,v $
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
my $EMAIL_PAGE = '/final/emailfile.html';
my $EMAIL_CONFIRM_PAGE = '/final/emailconfirm.html';
my $EMAIL_SCRIPT = '/cgi-bin/emailfile.pl';
my $ERROR_PAGE = '/final/error.html';
my $VIEW_SCRIPT = '/cgi-bin/viewlib.pl';

sub main();
sub error_page ($$$);

main();

sub main() {
  my $cgi = new CGI;
  my $file = $cgi->param('file');
  my $page = $cgi->param('page');
  my $username = $cgi->param('u');
  
  if (! $page || $page == 1) {
    # Show them the email page, customized for their own username so we
    # can track their activities.
    my $page_name = $ENV{'DOCUMENT_ROOT'} . $EMAIL_PAGE; 
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
  else {
    # Send the file to the email address.
    my $email = $cgi->param('email');
    my $file = $cgi->param('file');
  
    if (! $email) {
      # Send them an error message, allowing them to go back the email page.
      my $error = "You did not enter an email address.";
      error_page($error, $file, $username);
    }
    else {
      # Send the email on its way.
      my $real_lib_dir = $ENV{'DOCUMENT_ROOT'} . $LIB_DIR;
      my $command = 
        "mail -s \"Nightingale Library: ${file}\" $email < \"${real_lib_dir}/${file}\"";

      # Run the command and throw away the output.
      my $dummy = `$command`;

      # Show a confirmation message in the browser.
      my $page_name = $ENV{'DOCUMENT_ROOT'} . $EMAIL_CONFIRM_PAGE; 
      open(PAGE, $page_name);
      my @page = <PAGE>;
      close(PAGE);
  
      my $line;
      foreach $line (@page) {
        $line =~ s/email\@address.com/$username/;
        $line =~ s/\*email\*/$email/;
        $line =~ s/\*file\*/$file/;
      }
      print "Content-Type: text/html\n\n";
      print @page;
    }
  }
}

sub error_page ($$$) {
  my $error = shift;
  my $file = shift;
  my $username = shift;

  my $message = "<br><h2>Email Error</h2>";
  $message .= "<p>$error</p>";
  $message .= "<p>Please <a href=\"${EMAIL_SCRIPT}?file=${file}&u=${username}\">try again</a>.</p>";
  
  my $page_name = $ENV{'DOCUMENT_ROOT'} . $ERROR_PAGE; 
  open(PAGE, $page_name);
  my @page = <PAGE>;
  close(PAGE);

  my $line;
  foreach $line (@page) {
    $line =~ s/email\@address.com/$username/;
    $line =~ s/<!-- message -->/$message/;
  }
  print "Content-Type: text/html\n\n";
  print @page;
}
