#!/bin/bash
# freepbx Find and clean files more than 7 days old from the current date
# execute chmod +x for /root/setupmenu/src/audiofilesclean.sh
# add crontab job - 10 01 * * * /bin/bash /root/setupmenu/src/audiofilesclean.sh

dir_path="/var/spool/asterisk/monitor/"
log_file="/var/log/audiofilesclean.log"

#clean log before start
> $log_file

# Log the start of the operation
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting cleanup of files older than 7 days in ${dir_path}" >> "${log_file}"

# Find and clean files more than 7 days old from the current date
find "${dir_path}" -type f -mtime +7 -exec rm -v {} \; >> "${log_file}" 2>&1

# Log completion of the operation
echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleanup completed" >> "${log_file}"