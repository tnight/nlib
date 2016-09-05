#!e:/perl/bin/perl -w
#===========================================================================
# $Id: mailupdates.pl,v 1.3 2003/03/19 03:46:59 terryn Exp $
#
# Send out notifications to subscribers when library files change.
#
# $Log: mailupdates.pl,v $
# Revision 1.3  2003/03/19 03:46:59  terryn
# Changed mail script to send the file rather than just a notification
# that the file has been changed.  The latter functionality is what
# was specified in the original requirements.
#
# Revision 1.2  2003/03/19 03:24:51  terryn
# Removed debug message showing mail command.
#
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

use strict;

sub main();

main();

sub main () {

  my $server_root = '/cygdrive/c/Program Files/Apache Group/Apache'; 
  my $lib_dir = "${server_root}/htdocs/final/lib";
  my $update_file = "${server_root}/cgi-bin/updates.txt";

  my @updates = `/bin/sort "$update_file" | /usr/bin/uniq`;
  my $line;
  my $user;
  my $file;
  my $full_path;
  my @file_info;
  my $time;
  my $command;
  foreach $line (@updates) {
    chomp $line;
    ($user, $file) = split(/\t/, $line);
    $full_path = $lib_dir . "/" . $file;
    @file_info = stat "$full_path"
      or die "Could not stat $full_path: $!\n";
    
    # Check whether the file has been modified in the last day 
    # (86400 seconds).
    if ($file_info[9] >= (time() - 86400)) {
      $time = localtime($file_info[9]);
      $command = 
        "/bin/mail -s \"Nightingale Library: ${file} was updated at ${time}\" $user < \"${full_path}\"";

      # Run the command and throw away the output.
      my $dummy = `$command`;

    }
  }
}

# End of script
