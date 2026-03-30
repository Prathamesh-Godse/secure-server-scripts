#!/bin/bash

LOG_FILE="/home/ubuntuserver/secure-server-scripts.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

log "========== SCRIPT 2 STARTED =========="
log "hello 2"
