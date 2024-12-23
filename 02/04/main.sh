#!/bin/bash

CODE_RESPONSE=(200 201 400 401 403 404 500 501 502 503)
METHOD_HTTP=("GET" "POST" "PUT" "PATCH" "DELETE")
AGENT=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
URL="https://google.com"
COUNT_FILES=5
RAND_NUM_1=100
RAND_NUM_2=1000

for (( i=1; i < $((COUNT_FILES + 1)); i++ )); 
do
    > "nginx_$i.log"
    TIME=$(date +"%F %H:%M:%S")
    for ((j=1; j < $(shuf -i "$RAND_NUM_1"-"$RAND_NUM_2" -n 1); j++ ));
    do
        IP="$(($RANDOM % (256))).$(($RANDOM % (256))).$(($RANDOM % (256))).$(($RANDOM % (256)))"
        TIME="$(date +%d/%B/%Y:%H:%M:%S -d "($TIME) +${j}mins +$((RANDOM % 60))sec") $(date +%z)"
        RAND_METHOD=${METHOD_HTTP[$((RANDOM % ${#METHOD_HTTP[@]}))]}
        RAND_CODE=${CODE_RESPONSE[$((RANDOM % ${#CODE_RESPONSE[@]}))]}
        RAND_AGENT=${AGENT[$((RANDOM % ${#AGENT[@]}))]}
        INFO="$IP - - [$TIME] \"$RAND_METHOD HTTP/1.1\" $RAND_CODE $URL \"$RAND_AGENT\""
        echo -e "$INFO" >> "nginx_$i.log"
    done
done