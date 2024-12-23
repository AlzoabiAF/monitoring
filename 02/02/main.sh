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
        echo "$log_path - `date +"%d %b %Y %H:%M:%S"` - "Create directory"" >> `pwd`/generate_files_02.log
    else
        echo "$log_path - `date +"%d %b %Y %H:%M:%S"` - $log_size - "Create file"" >> `pwd`/generate_files_02.log
    fi
}
 
function create {
    local name_dir=$name_dirs
    while [[ ${#name_dir} -le 7 ]];
    do
        mkdir -p $link/$name_dir\_$date
        logger $link/$name_dir\_$date 0
        new_filename=$fname   
        while [[ ${#new_filename} -le 7 ]];
        do
            if [[ $(df -h / | awk '/G/ {print $4}' | awk -F'[^0-9]*' '{print $1}') -le 1 ]]; then 
                echo "less than a gigabyte of memory"
                exit 1 
            fi
            create_file $size_files"MB" $link/$name_dir\_$date/$new_filename\_$date"."$extension
            logger $link/$name_dir\_$date/$new_filename\_$date"."$extension $size_files"KB"
            new_filename=$new_filename${new_filename: -1}
        done
        name_dir=$name_dir${name_dir: -1}
    done
}

function generate {
	export date=$(date +"%d%m%y")
	while [[ ${#name_dirs} -lt 5 ]];
	do
		name_dirs=$name_dirs${name_dirs: -1}
	done
	fname=${name_files%.*}
	extension=${name_files#*.}
    while [[ ${#fname} -lt 5 ]];
	do
		name_files=${name_files:0:1}$name_files
		fname=${name_files%.*}
	done
	create
}

name_dirs=$1
name_files=$2
size_files=${3//[^0-9]/}

# ----------!!!!!!!!!! здесь должен быть / а не ./test 
# ------ В целях безопасности вашей системы ----------------------                    
readarray -t dir < <(find ./test -maxdepth 100 -type d -not -path "*bin*")

for link in ${dir[@]}; do
    generate 
done


