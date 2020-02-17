#!/bin/bash
#installing zabbix-agent to Centos 6.6 and configure to our zabbix server
hname=`hostname`
echo -e "\nPlease enter the zabbix-agent port. (not zabbix-server port)"
read port;
irule=$(iptables -vnL INPUT | grep -oE '$port')
system=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
	if [ "$system" == "6.6" ];
		then
        rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-release-4.2-2.el6.noarch.rpm
        yum install zabbix-agent -y
        Pak=$(yum list installed | grep -oE 'zabbix-agent')
                    if [ "$Pak" == "zabbix-agent" ]
                    then echo "zabbix-agent installed for $system"
                        else echo "Package not installed!"
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
            echo "You have installed actual Centos. Starting default setup script"
            bash /root/setupmenu/src/izab.sh
    fi
