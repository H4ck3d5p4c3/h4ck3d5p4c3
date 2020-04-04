# NMAP Parser

This is a bash NMAP Parser script that takes the input of an NMAP scan of multiple machines and will organization the services that
are open and list the IP Addresses that have that service open under them. 

After further research I found that there is a one line awk way of doing this below:

cat NMap_all_hosts.txt | awk '/Nmap scan/ { ip=$5 }/tcp.*open/ { print $1,$3,ip }' | tr '/' ' ' | sort | awk '{ if (a==$3) { print $4 } else { print $3, "\n" $4 }; a=$3 }'
