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

RESET='\033[0m'

INFO="$1$2HOSTNAME${RESET} = $3$4$hostname${RESET}
$1$2TIMEZONE${RESET} = $3$4$timezone${RESET}
$1$2USER${RESET} = $3$4$user${RESET}
$1$2OS${RESET} = $3$4$os${RESET}
$1$2DATE${RESET} = $3$4$date${RESET}
$1$2UPTIME${RESET} = $3$4$uptime${RESET}
$1$2UPTIME_SEC${RESET} = $3$4$update_sec${RESET}
$1$2IP${RESET} = $3$4$ip${RESET}
$1$2MASK${RESET} = $3$4$mask${RESET}
$1$2GATEWAY${RESET} = $3$4$gateway${RESET}
$1$2RAM_TOTAL${RESET} = $3$4$ram_total${RESET}
$1$2RAM_USED${RESET} = $3$4$ram_used${RESET}
$1$2RAM_FREE${RESET} = $3$4$ram_free${RESET}
$1$2SPACE_ROOT${RESET} = $3$4$space_root${RESET}
$1$2SPACE_ROOT_USED${RESET} = $3$4$space_root_used${RESET}
$1$2SPACE_ROOT_FREE${RESET} = $3$4$space_root_free${RESET}"

echo -e "$INFO"