#!/bin/sh
echo $0
echo "syntax : " $0 IP
# constantes
HOST=$1
LOGIN=anonymous
PASSWORD=randompass
PORT=21
ftp -i -n $HOST $PORT << END_SCRIPT
quote USER $LOGIN
quote PASS $PASSWORD
dir
quit
END_SCRIPT
