#!/bin/bash
#This script setup Zabbix-agent to Centos 7 and configure to our zabbix-server.
hname=`hostname`
echo -e "\nPlease enter the zabbix-agent port.(not zabbix-server port)"
read port;
irule=$(iptables -vnL INPUT | grep -oE '$port')
system=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
	if [ "$system" == "6.6" ];
		then
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-agent-4.2.5-1.el6.x86_64.rpm
Pak=$(yum list installed | grep -oE 'zabbix-agent')
if [ "$Pak" == "zabbix-agent" ]
then 
echo "zabbix-agent installed for $system"
else 
echo "Package not installed! Trying start another setup script"
bash /root/setupmenu/src/izab2.sh
exit
                fi
                    replace "Server=127.0.0.1" "Server=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                        replace "ServerActive=127.0.0.1" "ServerActive=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                            replace "Hostname=Zabbix server" "Hostname=$hname" -- /etc/zabbix/zabbix_agentd.conf                    
                                replace "# ListenPort=10050" "ListenPort=$port" -- /etc/zabbix/zabbix_agentd.conf
                                    service zabbix-agent restart
                                    chkconfig zabbix-agent on
                                    if [ "$irule" == "$port" ]
                                        then echo "This $irule already exists"
                                        else 
                                            iptables -A INPUT -p tcp --dport $port -m state --state NEW,ESTABLISHED -j ACCEPT
                                                service iptables save
                                    fi
        else
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-agent-4.2.5-1.el7.x86_64.rpm
Pak=$(yum list installed | grep -oE 'zabbix-agent')
if [ "$Pak" == "zabbix-agent" ]
then echo "zabbix-agent installed for $system"
else echo "Package not installed! Trying start another setup script"
exit
fi
                            replace "Server=127.0.0.1" "Server=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                replace "ServerActive=127.0.0.1" "ServerActive=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                    replace "Hostname=Zabbix server" "Hostname=$hname" -- /etc/zabbix/zabbix_agentd.conf
                                        replace "# ListenPort=10050" "ListenPort=$port" -- /etc/zabbix/zabbix_agentd.conf
                                            systemctl restart zabbix-agent
                                            systemctl enable zabbix-agent
                                            if [ "$irule" == "$port" ]
                                                then echo "This $irule already exists"
                                                else 
                                                    iptables -A INPUT -p tcp --dport $port -m state --state NEW,ESTABLISHED -j ACCEPT
                                                        service iptables save
                                            fi
    fi
    