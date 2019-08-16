#!/bin/bash
#Скрипт установки zabbix-agent на хост и его базовая настройка

hname=`hostname`
system=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
	if [ "$system" == "6.6" ];
		then
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-agent-4.2.5-1.el6.x86_64.rpm
                replace "Server=127.0.0.1" "Server=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                    replace "ServerActive=127.0.0.1" "ServerActive=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                        replace "Hostname=Zabbix server" "Hostname=$hname" -- /etc/zabbix/zabbix_agentd.conf
                            echo "Установлен zabbix-agent под $system"
                                service zabbix-agent restart
        else
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-agent-4.2.5-1.el7.x86_64.rpm
                replace "Server=127.0.0.1" "Server=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                    replace "ServerActive=127.0.0.1" "ServerActive=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                        replace "Hostname=Zabbix server" "Hostname=$hname" -- /etc/zabbix/zabbix_agentd.conf
                            echo "Установлен zabbix-agent под $system"
                                systemctl restart zabbix-agent
    fi