#!/bin/bash
clear
total_ip=$(iptables-save | grep -w REJECT | awk '{print "["NR"]-[ "$8" ]-""[",$4,"]"}' | awk '{gsub("-port-unreachable","");print}' | wc -l);
reason=$(iptables-save | grep -w "$1" | awk '{print $8}' | awk '{gsub("-port-unreachable",""); print}');
validate='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'

if [ -z "$1" ]
then
        echo "==============================="
        echo "Total of $total_ip" IP blocked
        echo "==============================="
        iptables-save | grep -w REJECT | awk '{print "["NR"]-[ "$8" ]-""[",$4,"]"}' | awk '{gsub("-port-unreachable","");print}' | awk '{gsub("/32",""); print}'
else
        if [[ $1 =~ ^$validate\.$validate\.$validate\.$validate$ ]];
        then
                if [ -z $(iptables-save | grep -w $1 | awk '{print $4}' | awk '{gsub("/32",""); print}') ]
                then
                        echo "IP "$1" is not listed in fail2ban"
                else
                        echo "====================================================="
                        echo "The IP [ $1 ] is blocked for [ $reason ]"
                        echo "====================================================="
                        echo "IP DETAILS:"
                        curl ipinfo.io/$1
                fi
        else
                echo "[ "$1" ] is not a valid IP address"
        fi
fi
