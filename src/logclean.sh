#!/bin/bash
#this is log cleaner

PATH=/var/log
PATHA=/var/log/asterisk
RM=/usr/bin/rm

echo "cleaning system logs"
{ 
$RM -rvf $PATH/secure-*
$RM -rvf $PATH/spooler-*
$RM -rvf $PATH/vsftpd.log-*
$RM -rvf $PATH/yum.log-*
$RM -rvf $PATH/monitorix-*
$RM -rvf $PATH/messages-*
$RM -rvf $PATH/maillog-*
$RM -rvf $PATH/itgrix_bx.log-*
$RM -rvf $PATH/itgrix_amo.log-*
$RM -rvf $PATH/fail2ban.log-*
$RM -rvf $PATH/cron-*
$RM -rvf $PATH/boot.log-*
} &> /dev/null
echo "System log clean done"
echo "Start cleaning asterisk logs job"
{
$RM -rvf $PATHA/backup-* 
$RM -rvf $PATHA/core-fastagi_out.log-*
$RM -rvf $PATHA/fail2ban-*
$RM -rvf $PATHA/freepbx.log-*
$RM -rvf $PATHA/firewall.log.*
$RM -rvf $PATHA/full-*
$RM -rvf $PATHA/queue_log-*
$RM -rvf $PATHA/secure.*
$RM -rvf $PATHA/ucp_err.log-*
$RM -rvf $PATHA/ucp_out.log-*
$RM -rvf $PATHA/security.*
$RM -rvf $PATHA/cel_prostiezvonki_*
} &> /dev/null
echo "Asterisk log clean done"
#free some logs
{
echo > $PATHA/fail2ban
echo > $PATHA/firewall.err
echo > $PATHA/firewall.log
echo > $PATHA/security
echo > $PATHA/secure
echo > $PATH/secure
echo > $PATH/fail2ban.log
echo > $PATH/core-fastagi_out.log
echo > $PATH/freepbx.log
echo > $PATH/cron
} &> /dev/null
echo "All jobs done"
echo -e "press any key to continue"
read -s -n 1