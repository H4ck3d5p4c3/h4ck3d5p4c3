#!/bin/bash
declare -a TOP
declare -a BOT
declare -a SERV
#declare -i NIPLoc=0
NIPLoc=0
servCnt=0
whichFunc=0
while IFS='' read -r line || [[ -n "$line" ]]
do
	if [[ $line == "Nmap scan report for"* ]]
	then
	#	: 
		TOP[$NIPLoc]="IP"
		BOT[$NIPLoc]="$(echo $line | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')"
		NIPLoc=$((NIPLoc+1))
	elif [[ $line =~ ^[0-9]{1,5}\/tcp ]]
	then
		#read aport aservice <<< $( echo ${line} | awk -F" " '{ print $1 " " $3}' )
		read aport isOpen aservice <<< $( echo ${line} | awk -F" " '{ print $1 " " $2 " " $3}' )
		if [[ $isOpen == "open" ]] 
		then
			TOP[$NIPLoc]="$(echo $aservice)"
			BOT[$NIPLoc]="$(echo $aport | grep -oE '[0-9]{1,5}')"
			NIPLoc=$((NIPLoc+1))
		fi
	fi 


done < NMAP_results.txt

for (( i=0;i<$NIPLoc;i++  )) do
	if [[ ${TOP[$i]} != "IP" ]]
	then
#	echo ${TOP[$i]}
	entBool=false
	for (( j=0;j<$servCnt;j++ )) do
		if [[ ${SERV[$j]} == ${TOP[$i]}  ]]
		then
			entBool=true 
		fi
	done	
	if [[ $entBool == false  ]]
                then
                        SERV[$j]=${TOP[$i]}
			servCnt=$((servCnt+1))
#			echo "just added: " ${SERV[$j]}
#			echo "it is number: " $servCnt
                fi
	fi
done

if [[ $whichFunc == 0  ]]
then
	for (( i=0;i<$servCnt;i++  )) do
		printf "**********\n"
		printf "${SERV[$i]}\n"
		printf "**********\n"
		for (( j=0;j<$NIPLoc;j++  )) do
			if [[ ${SERV[$i]} == ${TOP[$j]}  ]]
			then
				for (( k=j;k>0;k--  )) do
					if [[ ${TOP[$k]} == "IP"  ]]
					then
						echo ${BOT[$k]}
						break
					fi
				done
			fi
		done
		printf "===========\n\n"
	done
fi

#for (( j=0;j<$NIPLoc;j++ )) do
#		echo ${TOP[$j]}
#		echo ${BOT[$j]}
#done
