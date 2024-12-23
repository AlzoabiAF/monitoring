#!/bin/bash

if [[ $# -ne 6 ]]; then 
    echo "There should be 6 arguments"
    exit 1
fi

if [[ !(-d $1) ]]; then 
    echo "Directory not exist"
    exit 1
fi

re='^[0-9]+$'
if [[ $2 =~ re && $2 -lt 0 ]]; then 
    echo "Incorrect the count subfolder"
    exit 1
fi

eng='^[a-z]{1,7}$'
if ! [[ $3 =~ $eng ]]; then 
    echo "Incorrect the english symbol list "
    exit 1
fi

re='^[0-9]+$'
if [[ $4 =~ re && $4 -lt 0 ]]; then 
    echo "Incorrect the count files"
    exit 1
fi

if ! [[ "$(echo "$5" | awk -F. '{print $1}')" =~ $eng && "$(echo "$5" | awk -F. '{print $2}')" =~ ^[a-z]{1,3}$ ]]; then
    echo "Incorrect the count subfolder"
    exit 1
fi

if ! [[ $6 == *kb && $(echo "$6" | awk -Fkb '{print $1}') -le 100 ]]; then
    echo "Incorrect the size file"
    exit 1
fi

if [[ $(awk '/MemFree/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo) < "1.0" ]]; then
    echo "less than a gigabyte of memory"
    exit 1
fi
