#!/bin/bash

OUTPUT_FILE="/var/www/html/metrics.html"

while true; do
    # Сбор метрик
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    MEMORY_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
    MEMORY_AVAILABLE=$(free -m | awk '/^Mem:/{print $7}')
    DISK_TOTAL=$(df -m / | awk 'NR==2 {print $2}')
    
    # Формирование HTML
    echo "<html><body>" > $OUTPUT_FILE
    echo "<h1>System Metrics</h1>" >> $OUTPUT_FILE
    echo "<p>CPU Usage: $CPU_USAGE%</p>" >> $OUTPUT_FILE
    echo "<p>Memory Total: ${MEMORY_TOTAL}MB</p>" >> $OUTPUT_FILE
    echo "<p>Memory Available: ${MEMORY_AVAILABLE}MB</p>" >> $OUTPUT_FILE
    echo "<p>Disk Total: ${DISK_TOTAL}MB</p>" >> $OUTPUT_FILE
    echo "</body></html>" >> $OUTPUT_FILE

    sleep 3
done