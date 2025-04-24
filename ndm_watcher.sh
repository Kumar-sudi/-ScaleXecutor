#!/bin/bash

# Configurable variables
NDM_WATCH_DIR="/ndm/incoming"
NDM_PROCESSED_DIR="/ndm/processed"
NDM_LOG_FILE="/var/log/ndm_watcher.log"
SCALEXECUTOR_CMD="/opt/scalexecutor/control_thread.sh"
LOAD_THRESHOLD=70
CHECK_INTERVAL=60  # in seconds

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$NDM_LOG_FILE"
}

check_system_load() {
    # This uses the 1-minute load average, adjust as needed for your environment
    load=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | xargs | cut -d'.' -f1)
    echo "$load"
}

trigger_scalexecutor() {
    log "Triggering ScaleXecutor due to NDM file arrival and high system load"
    bash "$SCALEXECUTOR_CMD" &
}

process_ndm_files() {
    for file in "$NDM_WATCH_DIR"/*; do
        [ -e "$file" ] || continue
        log "Detected NDM file: $file"
        mv "$file" "$NDM_PROCESSED_DIR/"
        system_load=$(check_system_load)
        if [ "$system_load" -ge "$LOAD_THRESHOLD" ]; then
            trigger_scalexecutor
        else
            log "System load ($system_load) below threshold ($LOAD_THRESHOLD), not triggering"
        fi
    done
}

# Main loop
log "NDM Watcher started"
while true; do
    process_ndm_files
    sleep "$CHECK_INTERVAL"
done
