#!/bin/bash

# Configuration
hn=$(hostname)
EMAIL="support@rsloc.ru"
LOGFILE="/var/log/disk_health_check.log"
SUBJECT="$hn Disk Health Warning"
THRESHOLD=3

# Function to install smartctl if not present
install_smartctl() {
    echo "smartctl is not installed. Installing..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y smartmontools
    elif command -v yum &> /dev/null; then
        sudo yum install -y smartmontools
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y smartmontools
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm smartmontools
    else
        echo "Package manager not found. Please install smartctl manually."
        exit 1
    fi
}

# Check if smartctl is installed
if ! command -v smartctl &> /dev/null; then
    install_smartctl
    if ! command -v smartctl &> /dev/null; then
        echo "Failed to install smartctl. Exiting."
        exit 1
    fi
fi

# Get list of all disks and check their health
for disk in $(lsblk -dn -o NAME | grep -v '^loop' | grep -v '^sr'); do
    device="/dev/$disk"
    
    # Check disk health
    if smartctl_output=$(smartctl -a "$device" 2>/dev/null); then
        relocated_sectors=$(echo "$smartctl_output" | grep "Reallocated_Sector_Ct" | awk '{print $10}')

        # Check if relocated sectors count is found
        if [ -n "$relocated_sectors" ]; then
            # Check if relocated sectors exceed threshold
            if [ "$relocated_sectors" -gt "$THRESHOLD" ]; then
                # Prepare email content
                echo "Warning: The disk $device has relocated sectors greater than $THRESHOLD. Current count: $relocated_sectors" > /tmp/email_body.txt
                echo "Attached is the log file for detailed information." >> /tmp/email_body.txt
                
                # Send email with attachment
                echo "Sending email to $EMAIL"
                mailx -s "$SUBJECT" -a "$LOGFILE" "$EMAIL" < /tmp/email_body.txt
                
                # Clean up
                rm /tmp/email_body.txt
            else
                echo "Disk $device health is normal. Relocated sectors count: $relocated_sectors" | tee -a "$LOGFILE"
            fi
        else
            echo "Reallocated_Sector_Ct attribute not found for disk $device" | tee -a "$LOGFILE"
        fi
    else
        echo "Failed to retrieve smartctl data for disk $device" | tee -a "$LOGFILE"
    fi
done

# Clean up
rm -f /tmp/relocated_sectors.txt
echo -e "press any key to continue"
read -s -n 1