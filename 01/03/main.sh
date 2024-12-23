#!/bin/bash

if [ $# -ne 4 ] ; then 
    echo "There should be 4 parameters"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CHECK_RANGE="$SCRIPT_DIR/check_range.sh"
OUTPUT_INFO="$SCRIPT_DIR/output_info_system.sh"

chmod +x $CHECK_RANGE
args=("$@")
for ((i=0; i<${#args[@]}; i++)); do
    $CHECK_RANGE ${args[i]}
    if [[ $? -eq 1 ]] ; then
        echo "The numbers must be in the range from 1 to 6. Run the script again."
        exit 1;
    fi
    if [[ $((i % 2)) -eq 1 && ${args[i]} -eq  ${args[i - 1]} ]]; then
        echo "The font color should not match the background color.";
        exit 1; 
    fi 
    eval "color$i=${args[i]}"
done

#foreground
WHITE_FG='\033[1;37m' 
RED_FG='\033[1;31m'
GREEN_FG='\033[1;32m'
BLUE_FG='\033[1;34m'
PURPLE_FG='\033[1;35m'
BLACK_FG='\033[1;30m'
COLOR_FG=("$WHITE_FG" "$RED_FG" "$GREEN_FG" "$BLUE_FG" "$PURPLE_FG" "$BLACK_FG")

#background
WHITE_BG='\033[47m'
RED_BG='\033[41m'
GREEN_BG='\033[42m'
BLUE_BG='\033[44m'
PURPLE_BG='\033[45m'
BLACK_BG='\033[40m'
COLOR_BG=("$WHITE_BG" "$RED_BG" "$GREEN_BG" "$BLUE_BG" "$PURPLE_BG" "$BLACK_BG")


declare -a colors_args

for ((i=0; i<4; i++)); do
    index=$((args[i] - 1))
    if [[ $((i % 2)) -eq 1 ]]; then
        colors_args[i]=${COLOR_FG[index]}
    else 
        colors_args[i]=${COLOR_BG[index]}
    fi 
done 

chmod +x $OUTPUT_INFO
$OUTPUT_INFO ${colors_args[@]}