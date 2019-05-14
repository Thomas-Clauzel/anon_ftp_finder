#!/bin/bash
echo "
                             ______ _______ _____  ______ _           _           
     /\                     |  ____|__   __|  __ \|  ____(_)         | |          
    /  \   _ __   ___  _ __ | |__     | |  | |__) | |__   _ _ __   __| | ___ _ __ 
   / /\ \ | '_ \ / _ \| '_ \|  __|    | |  |  ___/|  __| | | '_ \ / _` |/ _ \ '__|
  / ____ \| | | | (_) | | | | |       | |  | |    | |    | | | | | (_| |  __/ |   
 /_/    \_\_| |_|\___/|_| |_|_|       |_|  |_|    |_|    |_|_| |_|\__,_|\___|_|   
                                                                                                                                                                  
"
echo "scan network for ftp server"
#range="192.168.1.1/24"
range="90.130.70.1/24"
echo $range will be scanned
echo "------------------"
nmap -p 21 $range >> liste_ftp.txt
grep -B 4 open liste_ftp.txt  >> liste_open.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" liste_open.txt >> ip_ftp_open.txt
cat ip_ftp_open.txt
echo "------------------"
echo "test ftp server for anonymous user"
# boucle sur les ip de ipftpopen 
cat ip_ftp_open.txt |  while read output
do
    echo "check for $output"
    nmap --script ftp-anon $output > tmp.txt
# Anonymous FTP login allowed
string1="Anonymous FTP login allowed"
	if grep -qF "$string1" tmp.txt;then
    		echo "Found it"
		grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" tmp.txt >> vulnerables_ftp.txt
	else
    		echo "Sorry this string not in file"
	fi
rm tmp.txt
rm liste_ftp.txt
rm liste_open.txt
rm ip_ftp_open.txt
echo "anonymous list ftp : "
cat vulnerables_ftp.txt	
done
