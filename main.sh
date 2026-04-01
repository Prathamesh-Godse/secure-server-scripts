#!/bin/bash

STATE_FILE="/home/<user>/current_stage.txt"

# If the file doesn't exist, start at stage 1
if [ ! -f "$STATE_FILE" ]; then
    echo 1 > "$STATE_FILE"
fi

STAGE=$(cat "$STATE_FILE")

case $STAGE in
    1)
        echo "Running Script 1..."
        #/home/user/scripts/script1.sh
        echo 2 > "$STATE_FILE"
        echo "Rebooting for Stage 2..."
        /usr/sbin/reboot
        ;;
    2)
        echo "Running Script 2..."
        #/home/user/scripts/script2.sh
        echo 3 > "$STATE_FILE"
        echo "Rebooting for Stage 3..."
        /usr/sbin/reboot
        ;;
    3)
        echo "Running Final Script..."
        #/home/user/scripts/script3.sh
        rm "$STATE_FILE"  # Clean up when finished
        echo "Sequence Complete!"
        ;;
    *)
        echo "No stage found or sequence finished."
        ;;
esac
