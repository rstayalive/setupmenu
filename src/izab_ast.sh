#!/bin/bash
#installing asterisk monitoring script to zabbix
eip=`fwconsole extip`
cp /root/setupmenu/src/asterisk_stat.sh /etc/zabbix/
replace "# Timeout=3" "Timeout=8" -- /etc/zabbix/zabbix_agentd.conf
replace "# SourceIP=" "SourceIP=$eip" -- /etc/zabbix/zabbix_agentd.conf
echo "UserParameter		= apache_status,/etc/zabbix/apache_stat.sh" >> /etc/zabbix/zabbix_agentd.conf
chmod 2750 /etc/zabbix; chgrp -R zabbix /etc/zabbix
chmod 640 /etc/zabbix/zabbix_agentd.conf
chmod 750 /etc/zabbix/asterisk_stat.sh
chgrp zabbix /etc/zabbix/asterisk_stat.sh
service zabbix-agent restart