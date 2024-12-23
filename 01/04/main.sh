#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CHECK_RANGE="$SCRIPT_DIR/check_range.sh"
OUTPUT_INFO="$SCRIPT_DIR/output_info_system.sh"
COLOR_CONF="$SCRIPT_DIR/color.conf"

if [ $# -ne 0 ]; then 
    echo "There should be no arguments"
    exit 1
fi

if [[ -f $COLOR_CONF ]]; then
chmod 777 $COLOR_CONF
    color_par=($(cat $COLOR_CONF | awk -F '=' '{print $2}'))
    exist_conf=1
else 
    echo "no exist file with color config"
    exist_conf=0
fi


if [[ $exist_conf -eq 1 && ${#color_par[@]} -eq 4 ]]; then
    for ((i=0; i<4; i++)); do 
        $CHECK_RANGE ${color_par[i]}
        if [[ $? -eq 1 ]] ; then
            echo "The numbers must be in the range from 1 to 6. Run the script again."
            exit 1;   
        fi
        if [[ $((i % 2)) -eq 1 && ${color_par[i]} -eq  ${color_par[i - 1]} ]]; then
            echo "The font color should not match the background color.";
            exit 1; 
        fi
    done
else 
    color_par=("6" "1" "6" "1")
fi

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
    index=$((color_par[i] - 1))
    if [[ $((i % 2)) -eq 1 ]]; then
        colors_args[i]=${COLOR_FG[index]}
    else 
        colors_args[i]=${COLOR_BG[index]}
    fi 
done 

chmod +x $OUTPUT_INFO
$OUTPUT_INFO ${colors_args[@]}

name_color=("white" "red" "green" "blue" "purple" "black")


if [ $exist_conf -eq 1 ]; then 
    INFO_COLOR="
Column 1 background = ${color_par[0]} (${name_color[${color_par[0]} - 1]})
Column 1 font color = ${color_par[1]} (${name_color[${color_par[1]} - 1]})
Column 2 background = ${color_par[2]} (${name_color[${color_par[2]} - 1]})
Column 2 font color = ${color_par[3]} (${name_color[${color_par[3]} - 1]})
"
else
    INFO_COLOR="
Column 1 background = default (${name_color[${color_par[0]} - 1]})
Column 1 font color = default (${name_color[${color_par[1]} - 1]})
Column 2 background = default (${name_color[${color_par[2]} - 1]})
Column 2 font color = default (${name_color[${color_par[3]} - 1]})
"
fi



echo -e "$INFO_COLOR"
