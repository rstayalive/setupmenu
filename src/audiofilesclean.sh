#!/bin/bash
#freepbx everyday records cleaner saved > 30 days
#insert line to cron job - crontab -e 0 0 * * * root /root/setupmenu/src/audiofilesclean.sh

dir_path="/var/spool/asterisk/monitor/"
#find and clean files more 30 days from current date
find "${dir_path}" -type f -mtime +30 -exec rm {} \;