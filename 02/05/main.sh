#!/bin/bash

echo -e "Вывести информацию из логов:\n  1. Все записи, отсортированные по коду ответа\n  2. Все уникальные IP, встречающиеся в записях\n  3. Все запросы с ошибками (код ответа — 4хх или 5хх)\n  4. Все уникальные IP, которые встречаются среди ошибочных запросов\n"
while true; do
    read -r -p "Введите число (1-4): " res
    case $res in
        [1-4]) break;;
        *) echo -e "\033[31mВведите число 1, 2, 3, 4.\033[0m";;
    esac
done

if [[ $res -eq 1 ]]; then
    for (( i=1; i <= 5; i++));
    do
        echo -e "\e[1m\e[35m04/nginx_$i.log:\e[0m"
        cat 04/nginx_1.log | sort -k8
    done
elif [ $res -eq 2 ]; then
    for (( i=1; i <= 1; i++));
    do
        echo -e "\e[1m\e[35m04/nginx_$i.log:\e[0m"
        cat "04/nginx_$i.log" | awk '!seen[$1]++'
    done
elif [ $res -eq 3 ]; then
    for (( i=1; i <= 5; i++));
    do
        echo -e "\e[1m\e[35m04/nginx_$i.log:\e[0m"
        cat "04/nginx_$i.log" | awk '$8 ~ /^4/ || $8 ~ /^5/ {print}'
    done
else
    for (( i=1; i <= 1; i++));
    do
        echo -e "\e[1m\e[35m04/nginx_$i.log:\e[0m"
        cat "04/nginx_$i.log" | awk '!seen[$1]++ && ($8 ~ /^4/ || $8 ~ /^5/) {print}'
    done
fi
