#!/bin/bash 
####################################
#The aim of this file is to supply a command line tool for sanitising Hard Disk Drives and Solid State Drives
#in line with guidance provided by the Australian Government Information security manual (https://www.cyber.gov.au)
#
#Sanitisation is required prior to equipment reuse, prior to dispoal, and can be used to bring HDD and SDDs from 
#PROTECTED to Official
#
#BE WARNED -- THIS WILL DESTROY YOUR DATA AND HURT THE WHOLE TIME IT DOES IT!
####################################
#List all hard drives
df
#Ask the user for a hard drive
echo –e "Please enter a filesystem as written in th Filesystem column: " 
read disk
read -p "This will destroy all data on $disk and is only suiatble for Solid State Disks. Are you sure you want to do this? (y/n)" answer
case ${answer:0:1} in
    y|Y )
          do
          ###################
          #Security Control: 0359; Revision: 3; Updated: Sep-18; Applicability: O, P, S, TS
          #Non-volatile flash memory media is sanitised by overwriting the media at least twice in its entirety with a random
          #pattern followed by a read back for verification
          ###################
          for number in 1 2 3 
          do 
          time dd if=/dev/urandom of=$disk bs=1M 
          echo "Random data write $number of 3 complete on $disk"
          done
          hexdump -C $disk 
          echo "Disk $disk is now sanitised"
    ;;
    * )
        echo "Exiting program"
    ;;
esac
