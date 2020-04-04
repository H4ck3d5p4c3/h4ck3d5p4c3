#!/bin/bash
#Establishes empty arrays for Service Names and IPs
NAME=()
VAL=()
#Sets index to zero
index=0

#Grab IP Service into variable
NAME=$(grep -E "\b([0-9]{1,3}\.){3}[0-9]{3}\b|\b+\/tcp\s*open" NMap_all_hosts.txt | awk '{print $NF }' )

#Push each part of variable into an array and increase index
for s in $NAME
do
VAL+=($s)
((index++))
done



#get the total count of the services
servicecnt=$(awk '/tcp.*open/ {print $3}' NMap_all_hosts.txt | sort -u | wc -l)
#get all services put into a string
array=$(awk '/tcp.*open/ {print $3}' NMap_all_hosts.txt | sort| uniq)
#create empty array
services=()

#parse services string and fill array with services
for x in $array
do
services+=($x)
done

#for each service at the index for servicecnt	
for (( i=0;i<$servicecnt;i++ )) do
	printf "================\n"
	printf "${services[$i]}\n"
	printf "================\n"
	#if service in array equals the service at the index n then do
	for (( n=0;n<$index;n++ )) do
		if [[ ${services[$i]} == ${VAL[$n]} ]]
		then
			#count backwards for index location of service until you reach an IP address and 
			#print the IP address
			for (( z=n;z>0;z-- )) do
				if [[ ${VAL[$z]} =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]
				then	
					echo ${VAL[$z]}
					break
				fi
			done
		fi
	done
	printf "================\n\n"
done

#grep -E "\b([0-9]{1,3}\.){3}[0-9]{3}\b|\b+\/tcp\s*open" NMAP_all_hosts.txt | awk '{print $NF }'
