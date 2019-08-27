#!/bin/bash
#Скрипт установки zabbix-agent на хост и его базовая настройка
hname=`hostname`
echo -e "\nВведите номер порта для zabbix-agent"
read port;
Pak=$(yum list installed | grep -oE 'zabbix-agent')
irule=$(iptables -vnL INPUT | grep -oE '$port')
system=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
	if [ "$system" == "6.6" ];
		then
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-agent-4.2.5-1.el6.x86_64.rpm
                if [ "$Pak" == "zabbix-agent" ]
                    then 
                        echo "Установлен zabbix-agent под $system"
                    else 
                        echo "Пакет не установился! Запускаю устанвоку второго варианта скрипта"
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
                                        then echo "правило уже есть"
                                        else 
                                            iptables -A INPUT -p tcp --dport $port -m state --state NEW,ESTABLISHED -j ACCEPT
                                                service iptables save
                                    fi
        else
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-agent-4.2.5-1.el7.x86_64.rpm
              if [ "$Pak" == "zabbix-agent" ]
                    then echo "Установлен zabbix-agent под $system"
                        else echo "Пакет не установился! Запускаю устанвоку второго варианта скрипта"
                        exit
                        fi
                            replace "Server=127.0.0.1" "Server=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                replace "ServerActive=127.0.0.1" "ServerActive=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                    replace "Hostname=Zabbix server" "Hostname=$hname" -- /etc/zabbix/zabbix_agentd.conf
                                        replace "# ListenPort=10050" "ListenPort=$port" -- /etc/zabbix/zabbix_agentd.conf
                                            systemctl restart zabbix-agent
                                            systemctl enable zabbix-agent
                                            if [ "$irule" == "$port" ]
                                                then echo "правило уже есть"
                                                else 
                                                    iptables -A INPUT -p tcp --dport $port -m state --state NEW,ESTABLISHED -j ACCEPT
                                                        service iptables save
                                            fi
    fi
    