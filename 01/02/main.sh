#!/bin/bash

hostname=$(hostname)
timezone="$(timedatectl show --value --property=Timezone) UTC $(date +%:z)"
user=$(whoami)
os=$(uname -s)
date=$(date +"%d %b %Y %X")
uptime=$(uptime -p)
uptime_sec=$(< /proc/uptime awk '{print $1}')
ip=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
mask=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f2)
gateway=$(ip route | grep "default\b" | awk '{print $3}')
ram_total=$(free | grep Mem | awk '{print $2}')
ram_used=$(free | grep Mem | awk '{print $3}')
ram_free=$(free | grep Mem | awk '{print $4}')
space_root=$(df -BM --total /root | grep "total\b" | awk '{print $2}')
space_root_used=$(df -BM --total /root | grep "total\b" | awk '{print $3}')
space_root_free=$(df -BM --total /root | grep "total\b" | awk '{print $4}')

INFO=$"HOSTNAME = $hostname
TIMEZONE = $timezone 
USER = $user
OS = $os
DATE = $date
UPTIME = $uptime
UPTIME_SEC = $update_sec
IP = $ip
MASK = $mask
GATEWAY = $gateway
RAM_TOTAL = $ram_total
RAM_USED = $ram_used
RAM_FREE = $ram_free
SPACE_ROOT = $space_root
SPACE_ROOT_USED = $space_root_used
SPACE_ROOT_FREE = $space_root_free"
echo "$INFO"

read -r -p "Do you want to write the data to a file? (Y/N): " answer
yes='[yY]'
if [[ $answer =~ $yes ]] ; then
    echo "$INFO" > $(date +"%d_%m_%y_%H_%M_%S.status")
fi


