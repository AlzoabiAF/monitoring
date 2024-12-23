#!/bin/bash

start=$SECONDS

if [[ $# -ne 1 ]]; then 
    echo "There should be 1 arg"
    exit 1
fi

DIR=$1

if [[ !(-d $DIR) ]]; then
    echo "it is not a directory"
	exit 1
fi

if [[ $DIR != */ ]]; then
	echo "incorrect input"
	exit 1
fi

#1
COUNT_DIR=$(find $DIR -type d | wc -l)

#2
FIRST_FIVE_DIR=$(du $DIR -h | sort -hr | head -n 5 | awk '{ printf "%d - %s/, %s\n", NR, $2, $1 }')

#3
TOTAL_FILES=$(find $DIR -maxdepth 1 -type f | wc -l)

#4
COUNT_CONF=$(find $DIR -maxdepth 1 -name "*.conf" | wc -l)
COUNT_TXT=$(find $DIR -maxdepth 1 -name "*.txt" | wc -l)
COUNT_EXEC=$(find $DIR -maxdepth 1 -type f -perm /a=x | wc -l)
COUNT_LOG=$(find $DIR -maxdepth 1 -name "*.log" | wc -l)
COUNT_ARCH=$(find $DIR -maxdepth 1 -name "*.tar" -name "*.gz" -name "*.zip" -name "*.rar" | wc -l)
COUNT_LINK=$(find $DIR -maxdepth 1 -type l | wc -l)

#5
COUNT=1
while read -r line; do
    type=$(echo "$line" | awk -F. '{print $NF}')
    if [[ $type == "1" ]]; then 
        type="null" 
    fi
    TOP_FILES="${TOP_FILES}$(echo "$line" | awk -v count="$COUNT" '{printf "%d - %s, %s,", count, $NF, $1}') $type\n"
    COUNT=$((COUNT + 1))
done < <(find $DIR -maxdepth 1 -type f -exec ls -RSsh {} \; 2>/dev/null | head -n 10)

#6
COUNT=1
while read -r line; do
    hash=$(echo "$line" | awk '{print $2}' | xargs shasum | awk '{print $1}')
    TOTAL_EXEC="${TOTAL_EXEC}$(echo "$line" | awk -v count="$COUNT" '{printf "%d - %s, %s,", count, $NF, $1}') $hash\n"
    COUNT=$((COUNT + 1))
done < <(find $DIR -maxdepth 1 -type f -perm /a=x -exec ls -RSsh {} \; 2>/dev/null | head -n 10)

#7
duration=$(( SECONDS - start ))

INFO="Total number of folders (including all nested ones) = $COUNT_DIR

TOP 5 folders of maximum size arranged in descending order (path and size):
$FIRST_FIVE_DIR

Total number of files = $TOTAL_FILES

Number of:
Configuration files (with the .conf extension) = $COUNT_CONF
Text files = $COUNT_TXT
Executable files = $COUNT_EXEC
Log files (with the extension .log) = $COUNT_LOG
Archive files = $COUNT_ARCH
Symbolic links = $COUNT_LINK

TOP 10 files of maximum size arranged in descending order (path, size and type):
$TOP_FILES
TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):
$TOTAL_EXEC
Script execution time (in seconds) = $duration
"

echo -e "$INFO"