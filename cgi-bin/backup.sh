#!c:/cygwin/bin/sh
#===========================================================================
# $Id: backup.sh,v 1.1 2003/03/19 02:32:40 terryn Exp $
#
# Make a backup of the library files and check it into RCS.
#
# $Log: backup.sh,v $
# Revision 1.1  2003/03/19 02:32:40  terryn
# Initial addition of all files in the nlib project.
#
#---------------------------------------------------------------------------

lib_dir="c:/program files/apache group/apache/htdocs/final/lib"
tar_dir="c:/junix"
tar_file="nlib-backup.tar"

cd $tar_dir
/usr/bin/tar -cf "$tar_file" "$lib_dir"
/usr/bin/rcs ci "$tar_file"

# End of script
