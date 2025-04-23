#!/bin/bash

CPU_THRESHOLD=80  # Customize this
ORACLE_USER="dbuser"
ORACLE_PASS="dbpass"
ORACLE_SID="ORCL"
LOG_FILE="/var/log/scalexecutor/db_monitor.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get average CPU usage (sample, customizable for your setup)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

echo "$TIMESTAMP - CPU Usage: $CPU_USAGE%" >> $LOG_FILE

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
  echo "$TIMESTAMP - Threshold breached. Triggering threads." >> $LOG_FILE
  /path/to/trigger_threads.sh
else
  echo "$TIMESTAMP - System load normal. No action taken." >> $LOG_FILE
fi
