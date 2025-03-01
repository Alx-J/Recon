#!/bin/bash 

if ["$1" == ""]
then
 echo "error"
 echo "syntax: ./netsweep.sh 10.10.10"
else
 for ip in $(seq 1 254); do
  ping -c 1 $1.$ip | grep "64 bytes" &> /dev/null
  if [ $? -eq 0 ]; then 
   echo "$1.$ip is alive"
   nmap -F $1.$ip
  fi
 done 
fi
