#!/bin/bash
# freepbx Find and clean files more than 365 days old from the current date based on disk filling more than 85%
# add crontab job - 10 01 * * * /bin/bash /root/setupmenu/src/audiofilesclean_disk.sh

# Setting disk / usage threshold
THRESHOLD=85
# asterisk voice records dir
MONITOR_DIR="/var/spool/asterisk/monitor"
#log file
log_file="/var/log/audiofilesclean.log"
#clean log before start
> $log_file

# Disk usage check func
check_disk_usage() {
    # getting disk usage percent /
    USAGE=$(df / | grep '/' | awk '{print $5}' | sed 's/%//')

    if [ "$USAGE" -gt "$THRESHOLD" ]; then
        echo "Disk usage more than $USAGE%. Erasing audio records .wav и .mp3..."
        # audio records clean more than 1 year old
        find "$MONITOR_DIR" -type f \( -name "*.wav" -o -name "*.mp3" \) -mtime +365 -exec rm -f {} \; >> "${log_file}" 2>&1
        echo "$(date '+%Y-%m-%d %H:%M:%S') Erasing done." >> "${log_file}"
    else
        echo "Normal disk usage. nothing to do: $USAGE%" >> "${log_file}"
    fi
}

# root privileges check
if [ "$EUID" -ne 0 ]; then
    echo "Please start script with root privileges."
    exit 1
fi

# Starting check
check_disk_usage