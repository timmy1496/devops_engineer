#!/usr/bin/env bash

LOG_FILE="/home/timmy/system_monitor.log"
DATE="$(date '+%Y-%m-%d %H:%M:%S')"

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}')

echo "$DATE | CPU: ${CPU_USAGE}% | MEM: ${MEM_USED}/${MEM_TOTAL} MB | DISK: ${DISK_USAGE} | LOAD:${LOAD_AVG}" >> "$LOG_FILE"
