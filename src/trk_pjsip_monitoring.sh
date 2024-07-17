#!/bin/bash
#FreePBX PJSIP cron trunk monitoring
#please add cron job example: - crontab -e */5 * * * * /path to script
#create a telegram bot or get bot TOKEN
#get your chat ID - Search for the userinfobot on Telegram and start a chat. Send /start and note down the chat ID that you receive in the response. This is where the bot will send messages.
# Telegram API token and chat ID
TELEGRAM_TOKEN=2060869224:AAH4k2ug5dAbBgEAlKjcPliAVAQoIdKzZIA
CHAT_ID=232107968
#get freepbx hostname for message
hname=`hostname`
#get external IP for message
extip=`fwconsole extip`

# FreePBX command to check trunk status
TRUNK_STATUS=$(asterisk -rx "pjsip list contacts" | grep -i "Unavail")

# Check if there are any unreachable trunks
if [[ ! -z "$TRUNK_STATUS" ]]; then
    MESSAGE="Trunk Failure Detected on $hname IP - $extip: $TRUNK_STATUS"
    # Send message to Telegram
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id=$CHAT_ID -d text="$MESSAGE"
fi