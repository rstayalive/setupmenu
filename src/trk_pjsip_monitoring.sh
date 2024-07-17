#!/bin/bash
#FreePBX PJSIP cron trunk monitoring
#please add cron job example: - crontab -e */5 * * * * /path to script

# Telegram API token and chat ID
TELEGRAM_TOKEN=2060869224:AAH4k2ug5dAbBgEAlKjcPliAVAQoIdKzZIA
CHAT_ID=232107968
hname=`hostname`
extip=`fwconsole extip`

# FreePBX command to check trunk status
TRUNK_STATUS=$(asterisk -rx "pjsip list contacts" | grep -i "Unavail")

# Check if there are any unreachable trunks
if [[ ! -z "$TRUNK_STATUS" ]]; then
    MESSAGE="Trunk Failure Detected on $hname IP - $extip: $TRUNK_STATUS"
    # Send message to Telegram
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id=$CHAT_ID -d text="$MESSAGE"
fi