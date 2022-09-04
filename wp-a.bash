#!/usr/bin/env bash
#
# WordPress Automation
# For educational purpose, heheh

function checkPath () {
    local url=$1
    getStatusCode=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [[ "$getStatusCode" == 200 ]]; then
        echo -e "\e[38;5;4minfo:\e[0m $url \e[38;5;11m[$getStatusCode] \e[38;5;10mfound\e[0m"
        echo "$url" >> found.txt
    elif [[ "$getStatusCode" == 302 ]]; then
        echo -e "\e[38;5;4minfo:\e[0m $url \e[38;5;11m[$getStatusCode] \e[38;5;10mfound, but redirect\e[0m"
        echo "$url" >> found.txt
    else
        echo -e "\e[38;5;4minfo:\e[0m $url \e[38;5;11m[$getStatusCode] \e[38;5;9mnot found\e[0m"
    fi
}


function check () {
    list=$1
    THREADS=$2

    for url in $(cat $list); do
        for path in $(cat path.txt); do
            ((cthread=cthread%THREADS)); ((cthread++==0)) && wait
            checkPath "${url}/${path}" & 
        done
    done
}

clear
cat << "banner"
  _      _____      ____           __     _ __ 
 | | /| / / _ \____/ __/_ __ ___  / /__  (_) /_
 | |/ |/ / ___/___/ _/ \ \ // _ \/ / _ \/ / __/
 |__/|__/_/      /___//_\_\/ .__/_/\___/_/\__/ 
                          /_/                  

banner
echo -ne "URLs list : "
read -r urls
echo -ne "Threads : "
read -r thread
check $urls $thread