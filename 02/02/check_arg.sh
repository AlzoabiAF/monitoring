#!/bin/bash

if [[ ${#@} -ne 3 ]]; then 
    echo "There should be 3 arguments"
    exit 1
fi

eng='^[a-z]{1,7}$'
if ! [[ $1 =~ $eng ]]; then 
    echo "Incorrect the english symbol list "
    exit 1
fi

if ! [[ "$(echo "$2" | awk -F. '{print $1}')" =~ $eng && "$(echo "$2" | awk -F. '{print $2}')" =~ ^[a-z]{1,3}$ ]]; then
    echo "Incorrect the count subfolder"
    exit 1
fi

if ! [[ $3 == *Mb && $(echo "$3" | awk -FMb '{print $1}') -le 100 ]]; then
    echo "Incorrect the size file"
    exit 1
fi

if [[ $(df -h / | awk '/G/ {print $4}' | awk -F'[^0-9]*' '{print $1}') -lt 1 ]]; then 
    echo "less than a gigabyte of memory"
    exit 1 
fi
