#!/bin/bash

# Get script directory
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Base directory
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# Config paths
ENABLED_CONFIG="$BASE_DIR/configs/ufw_enabled.conf"
DISABLED_CONFIG="$BASE_DIR/configs/ufw_disabled.conf"

# Logging function (temporary until config loaded)
LOG_FILE="/home/ubuntuserver/secure-server-scripts.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

# Check UFW
if ! command -v ufw &> /dev/null; then
    log "UFW not installed. Installing..."
    sudo apt update
    sudo apt install -y ufw
fi

# log "Resetting firewall"
# sudo ufw --force reset

log "========== UFW AUTO SCRIPT STARTED =========="

# Detect UFW state
 sudo ufw status >> "$LOG_FILE" 2>&1
if sudo ufw status | grep -q inactive; then

    log "UFW is INACTIVE"

    # Load disabled config
    if [ ! -f "$DISABLED_CONFIG" ]; then
        log "Config file missing: $DISABLED_CONFIG"
        exit 1
    fi

    source "$DISABLED_CONFIG"

    log "Checking UFW status..."
    sudo ufw status verbose >> "$LOG_FILE" 2>&1

    log "Setting default policies..."
    sudo ufw default $DEFAULT_INCOMING incoming >> "$LOG_FILE" 2>&1
    sudo ufw default $DEFAULT_OUTGOING outgoing >> "$LOG_FILE" 2>&1

    for port in $PORTS; do
        log "Allowing port: $port"
        sudo ufw allow $port >> "$LOG_FILE" 2>&1
    done

    log "Enabling UFW..."
    sudo ufw --force enable >> "$LOG_FILE" 2>&1

else

    log "UFW is ACTIVE"

    # Load enabled config
    if [ ! -f "$ENABLED_CONFIG" ]; then
        log "Config file missing: $ENABLED_CONFIG"
        exit 1
    fi

    source "$ENABLED_CONFIG"

    log "Checking UFW status..."
    sudo ufw status verbose >> "$LOG_FILE" 2>&1

    for port in $PORTS; do
        log "Allowing port: $port"
        sudo ufw allow $port >> "$LOG_FILE" 2>&1
    done

    log "Reloading UFW..."
    sudo ufw reload >> "$LOG_FILE" 2>&1

fi

# Ping rule
if [ "$ALLOW_PING" = "no" ]; then
    log "Disabling ping"
    sudo ufw deny proto icmp

else
    log "Ping allowed"
fi

# log "Enabling firewall"
# sudo ufw --force enable >> "$LOG_FILE" 2>&1

log "Reloading UFW..."
    sudo ufw reload >> "$LOG_FILE" 2>&1

log "Firewall configuration complete"


# Final status
log "Final UFW status:"
sudo ufw status verbose >> "$LOG_FILE" 2>&1
