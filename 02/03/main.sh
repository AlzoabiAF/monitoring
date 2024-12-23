#!/bin/bash

echo -e "Очистить систему:\n  1. По лог файлу\n  2. По дате и времени создания\n  3. По маске имени (т. е. символы, нижнее подчёркивание и дата).\n"
while true; do
    read -r -p "Введите число (1-3): " res
    case $res in
        [1-3]) break;;
        *) echo -e "\033[31mВведите число 1, 2, 3.\033[0m";;
    esac
done

remove_by_date() {
    readarray -t files_dir < <(find /)
    for file in ${files_dir[@]}; 
    do  
        if [[ "$(stat $file | grep 'Birth: ' | grep "$res")" != "" ]]; then
            rm -rf $file
        fi  
    done
}

remove_by_mask() {
    find / -name "$res.*" | xargs rm -rf
}

remove_by_log_file() {
    cat $res | awk '{print $1}' | xargs rm -rf
}

if [[ res -eq 1 ]]; then
    while true; do
        read -r -p "Введите путь лог файла: " res
        if [[ -f $res ]]; then 
            break
        fi
        echo -e "\033[31mВведите существующий лог файл\033[0m"
    done
    remove_by_log_file
elif [[ res -eq 2 ]]; then
    while true; do
        read -r -p $'Введите дату и время (\033[36mYYYY-MM-DD HH:MM\033[0m): ' res
        if [[ "$res" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then 
            break
        fi
        echo -e "\033[31mВведите корректную дату и время\033[0m"
    done
    remove_by_date
else
    while true; do
        read -r -p $'Введите маску имени (\033[36mabc_010124\033[0m): ' res
        if [[ ${res#*_} =~ [0-9]{6}$ && ${res%*_} =~ [a-zA-Z] ]]; then 
            break
        fi
        echo -e "\033[31mВведите корректную маску\033[0m"
    done
    remove_by_mask
fi
