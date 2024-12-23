#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CHECKING_ARG=$SCRIPT_DIR/check_arg.sh


bash $CHECKING_ARG $@
if [[ $? -ne 0 ]]; then 
    exit 1
fi


function create_file {
    size_dd=$1
    file_name_dd=$2
	dd if=/dev/zero of=$file_name_dd bs=$size_dd count=1 2>/dev/zero
}

function logger {
    log_path=$1
    log_size=$2

     if [[ $log_size == "0" ]]
	then
        echo "$log_path - `date +"%d %b %Y %H:%M:%S"` - "Create directory"" >> `pwd`/generate_files.log
    else
        echo "$log_path - `date +"%d %b %Y %H:%M:%S"` - $log_size - "Create file"" >> `pwd`/generate_files.log
    fi
}

function create {
	for (( i=0; i<$nest_dirs; i++ ))
	do
		mkdir -p $link/$name_dirs\_$date
		logger $link/$name_dirs\_$date 0
		new_filename=$fname

		for (( j = 1; j <= $num_of_files; j++ ))
		do
			if [[ $(df -h / | awk '/G/ {print $4}' | awk -F'[^0-9]*' '{print $1}') -lt 1 ]]; then 
				echo "less than a gigabyte of memory"
				exit 1 
			fi
			create_file $size_files"KB" $link/$name_dirs\_$date/$new_filename\_$date"."$extension
			logger $link/$name_dirs\_$date/$new_filename\_$date"."$extension $size_files"KB"
			new_filename=$new_filename${new_filename: -1}
		done
		name_dirs=$name_dirs${name_dirs: -1}
	done
}

function generate {
	for (( ; ${#name_dirs} < 4; ))
	do
		name_dirs=$name_dirs${name_dirs: -1}
	done
	fname=${name_files%.*}
	extension=${name_files#*.}
	for (( ; ${#fname} < 4; ))
	do
		name_files=${name_files:0:1}$name_files
		fname=${name_files%.*}
	done
	create
}

date=$(date +"%d%m%y")
link=$1
nest_dirs=$2
name_dirs=$3
num_of_files=$4
name_files=$5
size_files=${6//[^0-9]/}

generate
