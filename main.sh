#!/bin/bash

STATE_FILE="/home/ubuntuserver/current_stage.txt"
SERVICE_NAME="secure-server-scripts.service"

# If file doesn't exist → start at stage 1
if [ ! -f "$STATE_FILE" ]; then
    echo 1 > "$STATE_FILE"
fi

STAGE=$(cat "$STATE_FILE")

case $STAGE in
    1)
        echo "Stage 1: Running UFW Auto Setup..."

        /home/ubuntuserver/scripts/ufw_auto.sh

        echo 2 > "$STATE_FILE"
        echo "Rebooting for Stage 2..."
        /usr/sbin/reboot
        ;;

    2)
        echo "Stage 2: (Next task here)"
        # Example:
        /home/ubuntuserver/scripts/script2.sh

        echo 3 > "$STATE_FILE"
        echo "Rebooting for Stage 3..."
        /usr/sbin/reboot
        ;;

    3)
        echo "Stage 3: Final stage"
        # Example:
        /home/ubuntuserver/scripts/script3.sh

        rm "$STATE_FILE"
        echo "Sequence Complete!"

        systemctl disable "$SERVICE_NAME"
        # systemctl stop "$SERVICE_NAME"

        exit 0
        ;;

    *)
        echo "Invalid state. Resetting..."
        rm -f "$STATE_FILE"
        systemctl disable "$SERVICE_NAME"
        # systemctl stop "$SERVICE_NAME"

        exit 0
        ;;
esac
