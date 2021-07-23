#!/bin/bash
#NMAP.txt can be replace with nmap file in question
#cats out the main file the runs the file and takes all the services listed, rids duplicates and adds them all to a list
cat NMAP.txt | egrep '([0-9]){1,5}[\/](tcp|udp)' | awk -F ' ' '{ print $NF }' | sort -u > services.txt
#cats out main nmap file and takes all ips and their services the used
cat NMAP.txt | egrep -e '([0-9]{1,3}[.]){3}[0-9]{1,3}$' -e '([0-9]){1,5}[\/](tcp|udp)' | awk -F ' ' '{ print $NF }' > nmap_refined.txt 
#sets the var equal to the regex of an ip
IP_REGEX='([0-9]{1,3}[.]){3}[0-9]{1,3}$'
while read service; do
        counter=0
        iplist=()
        #sets counter to 0 and clears the array
        #reads each line in nmap_refined and sees if it is an ip and then  takes ip from line if it is an ip
        while read nmap_line; do
                if [[ $nmap_line =~ $IP_REGEX ]];
                then
                        #assigns ip to var to be added to array later
                        daip=$(echo $nmap_line | egrep '([0-9]{1,3}[.]){3}[0-9]{1,3}$')
                fi
                #checks if the line in the nmap_refined is a service and if so adds to the sevices counter
                if [[ $nmap_line = $service ]];
                then
                        #adds the ip to that services array
                        iplist+=("${daip}")
                fi 
        done<nmap_refined.txt
        #gets rid of dup ips
        sorted_ips=($(echo "${iplist[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
        #for loop for ip count, post sort
        for i in "${sorted_ips[@]}"
        do
                let counter++
        done
        #print lines to get the information and format need for the answers
        echo "Service: $service Count: $counter"
        echo "================================="
        ( IFS=$'\n'; echo "${sorted_ips[*]}" )
        printf "\n"

done <services.txt
