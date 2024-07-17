#!/bin/bash
#FreePBX PJSIP cron trunk monitoring
#please add cron job example: - crontab -e */5 * * * * /path to script
#create a telegram bot or get bot TOKEN
#get your chat ID - Search for the userinfobot on Telegram and start a chat. Send /start and note down the chat ID that you receive in the response. This is where the bot will send messages.
# Telegram API token and chat ID
#set config file to store token and chat id
config_file=~/trkmon_config.sh
#get freepbx hostname for message
hname=`hostname`
#get external IP for message
extip=`fwconsole extip`
#check config file exists
if [[ -e $config_file && -s $config_file ]];then
#set config file
source ~/trkmon_config.sh
# FreePBX command to check trunk status
TRUNK_STATUS=$(asterisk -rx "pjsip list contacts" | grep -i "Unavail")

# Check if there are any unreachable trunks
if [[ ! -z "$TRUNK_STATUS" ]]; then
    MESSAGE="Trunk Failure Detected on $hname IP - $extip: $TRUNK_STATUS"
    # Send message to Telegram
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" -d chat_id=$CHAT_ID -d text="$MESSAGE"
fi
else
#collect information and put to config file
read -p "Enter Telegram bot TOKEN: " ttoken
read -p "Enter Telegram chat ID: " tid
echo "TELEGRAM_TOKEN=\"$ttoken\"" > $config_file
echo "CHAT_ID=\"$tid\"" >> $config_file
chmod 600 ~/trkmon_config.sh
fi