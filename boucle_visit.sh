#!/bin/bash
cat vulnerables_ftp.txt |  while read output
do
    echo ""
    echo "VISITING $output"
    /home/user/scripts/anon_ftp_finder/visit_ftp.sh $output
    echo "-----------------------"
    echo ""
done
