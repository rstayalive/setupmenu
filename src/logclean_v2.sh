#!/bin/bash
# Log cleaner script

# Define paths
SYS_LOG_PATH="/var/log"
ASTERISK_LOG_PATH="/var/log/asterisk"
RM="/usr/bin/rm"

# Define log patterns to clean
SYS_LOG_PATTERNS=(
    "secure-*"
    "spooler-*"
    "vsftpd.log-*"
    "yum.log-*"
    "monitorix-*"
    "messages-*"
    "maillog-*"
    "itgrix_bx.log-*"
    "itgrix_amo.log-*"
    "fail2ban.log-*"
    "cron-*"
    "boot.log-*"
    "wtmp-*"
    "btmp-*"
    "dmesg-*"
    "lastlog-*"
)

ASTERISK_LOG_PATTERNS=(
    "backup-*"
    "core-fastagi_out.log-*"
    "fail2ban-*"
    "freepbx.log-*"
    "firewall.log.*"
    "full-*"
    "queue_log-*"
    "secure.*"
    "ucp_err.log-*"
    "ucp_out.log-*"
    "security.*"
    "cel_prostiezvonki_*"
)

# Function to clean logs
clean_logs() {
    local log_path=$1
    shift
    local patterns=("$@")

    for pattern in "${patterns[@]}"; do
        if ! $RM -rvf "$log_path/$pattern" &> /dev/null; then
            echo "Failed to remove $log_path/$pattern"
        fi
    done
}

# Clean system logs
echo "Cleaning system logs..."
clean_logs "$SYS_LOG_PATH" "${SYS_LOG_PATTERNS[@]}"
echo "System log cleaning done"

# Clean Asterisk logs
echo "Start cleaning Asterisk logs..."
clean_logs "$ASTERISK_LOG_PATH" "${ASTERISK_LOG_PATTERNS[@]}"
echo "Asterisk log cleaning done"

# Truncate logs to free up space
truncate_logs() {
    local log_path=$1
    shift
    local logs=("$@")

    for log in "${logs[@]}"; do
        if ! : > "$log_path/$log" &> /dev/null; then
            echo "Failed to truncate $log_path/$log"
        fi
    done
}

# Logs to truncate
SYS_TRUNCATE_LOGS=(
    "secure"
    "fail2ban.log"
    "core-fastagi_out.log"
    "freepbx.log"
    "cron"
)

ASTERISK_TRUNCATE_LOGS=(
    "fail2ban"
    "firewall.err"
    "firewall.log"
    "security"
    "secure"
)

# Truncate system logs
echo "Truncating system logs..."
truncate_logs "$SYS_LOG_PATH" "${SYS_TRUNCATE_LOGS[@]}"
echo "System log truncation done"

# Truncate Asterisk logs
echo "Truncating Asterisk logs..."
truncate_logs "$ASTERISK_LOG_PATH" "${ASTERISK_TRUNCATE_LOGS[@]}"
echo "Asterisk log truncation done"

echo "All jobs done"
echo -e "Press any key to continue"
read -s -n 1
