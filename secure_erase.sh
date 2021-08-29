#!/bin/bash 
df
#Ask the user for a hard drive
echo –e "Please enter a filesystem as written in th Filesystem column: " 
read disk
#
#Security Control: 1065; Revision: 2; Updated: Sep-18; Applicability: O, P, S, TS
#The host-protected area and device configuration overlay table of non-volatile magnetic media is reset prior to
#sanitisation.
#
echo "ATA 
hdparm --yes-i-know-what-i-am-doing --dco-restore $disk
#
#Security Control: 0354; Revision: 5; Updated: Sep-18; Applicability: O, P, S, TS
#Non-volatile magnetic media is sanitised by booting from separate media to the media being sanitised and then
#overwriting the media at least once (or three times if pre-2001 or under 15 Gigabytes) in its entirety with a random
#pattern followed by a read back for verification.
#
for number in 1 2 3 
do 
time dd if=/dev/urandom of=$disk bs=1M 
echo "Pass $number of 3 complete on $disk"
done
#
#Security Control: 1067; Revision: 3; Updated: Sep-18; Applicability: O, P, S, TS
#The ATA secure erase command is used where available, in addition to using block overwriting software, to ensure the
#growth defects table (g-list) is overwritten.
#
echo "Attempting ATA secure erase on $disk" 
pwor=$(openssl rand –base64 24) 
echo "New password is $pwor" 
time hdparm --user-master u --security-erase $pwor $disk 
echo "Disk $disk is now sanitised" 
