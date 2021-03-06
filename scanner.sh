#!/bin/bash
# ------------------------------------------------
# author : 0code
# title anon_ftp_finder.sh
# depenfencies : nmap
# description : a useful script to discover and attempt the login of the anonymous user on ftp servers 
# ------------------------------------------------
echo "                                                             
 _____             _____ _____ _____ _____ _       _         
|  _  |___ ___ ___|   __|_   _|  _  |   __|_|___ _| |___ ___ 
|     |   | . |   |   __| | | |   __|   __| |   | . | -_|  _|
|__|__|_|_|___|_|_|__|    |_| |__|  |__|  |_|_|_|___|___|_|  
                                                            
"
echo "Scan network for ftp server ..."
range="78.192.0.0/16"
echo $range "being scanned"
echo "------------------"
nmap -p 21 $range >> liste_ftp.txt
grep -B 4 open liste_ftp.txt  >> liste_open.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" liste_open.txt >> ip_ftp_open.txt
cat ip_ftp_open.txt
echo "------------------"
echo "Test ftp server for the anonymous user ..."
# boucle sur les ip de ipftpopen 
cat ip_ftp_open.txt |  while read output
do
    echo "check for $output"
    nmap --script ftp-anon $output > tmp.txt
    # Anonymous FTP login allowed
    string1="Anonymous FTP login allowed"
	if grep -qF "$string1" tmp.txt;then
    		echo "Vulnerable FTP FOUND !"
		grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" tmp.txt
		grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" tmp.txt >> vulnerables_ftp.txt
	fi
done
rm tmp.txt
rm liste_ftp.txt
rm liste_open.txt
rm ip_ftp_open.txt
echo "Anonymous ftp list : "
cat vulnerables_ftp.txt
echo "fin"
