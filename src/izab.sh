#!/bin/bash
#Скрипт установки zabbix-agent на хост и его базовая настройка

hname=`hostname`
system=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
	if [ "$system" == "6.6" ];
		then
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/6/x86_64/zabbix-agent-4.2.5-1.el6.x86_64.rpm
                if [ -z 'rpm -qa zabbix-agent' ]
                    then echo "Пакет не установился!" exit
                        else echo "Установлен zabbix-agent под $system" fi
                            replace "Server=127.0.0.1" "Server=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                replace "ServerActive=127.0.0.1" "ServerActive=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                    replace "Hostname=Zabbix server" "Hostname=$hname" -- /etc/zabbix/zabbix_agentd.conf
                                        mkdir -p /etc/zabbix/scripts
                                            cp /root/setupmenu/src/AT.zip /etc/zabbix/scripts/
                                                unzip /etc/zabbix/scripts/AT.zip
                                                chmod +x /etc/zabbix/scripts/*
                                                echo 
                                                "UserParameter=ast.up,/etc/zabbix/scripts/ast_up.sh

                                                UserParameter=calls.num,/etc/zabbix/scripts/calles_num.sh

                                                UserParameter=last.reload,/etc/zabbix/scripts/ast_uptime_last_reload.sh

                                                UserParameter=mmysql.stat,/etc/zabbix/scripts/mysql_status.sh

                                                UserParameter=regis.time,/etc/zabbix/scripts/ms_time.sh

                                                UserParameter=trunk.down,/etc/zabbix/scripts/trunk_down.sh

                                                UserParameter=worng.pass,/etc/zabbix/scripts/worng_pass.sh

                                                UserParameter=call.graf,/etc/zabbix/scripts/graf_calls.sh

                                                UserParameter=failban.stat,/etc/zabbix/scripts/fail2ban_up.sh

                                                UserParameter=iptables.up,/etc/zabbix/scripts/iptables_status.sh

                                                UserParameter=ast.crash,/etc/zabbix/scripts/ast_crashes.sh" >> /etc/zabbix/zabbix_agentd.conf
                                            service zabbix-agent restart
        else
            rpm -Uvh http://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-agent-4.2.5-1.el7.x86_64.rpm
                if [ -z 'rpm -qa zabbix-agent' ]
                    then echo "Пакет не установился!" exit
                        else echo "Установлен zabbix-agent под $system" fi
                            replace "Server=127.0.0.1" "Server=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                replace "ServerActive=127.0.0.1" "ServerActive=176.192.230.26" -- /etc/zabbix/zabbix_agentd.conf
                                    replace "Hostname=Zabbix server" "Hostname=$hname" -- /etc/zabbix/zabbix_agentd.conf
                                        mkdir -p /etc/zabbix/scripts
                                            cp /root/setupmenu/src/AT.zip /etc/zabbix/scripts/
                                            unzip /etc/zabbix/scripts/AT.zip
                                            chmod +x /etc/zabbix/scripts/*
                                            echo 
                                            "UserParameter=ast.up,/etc/zabbix/scripts/ast_up.sh

                                            UserParameter=calls.num,/etc/zabbix/scripts/calles_num.sh

                                            UserParameter=last.reload,/etc/zabbix/scripts/ast_uptime_last_reload.sh

                                            UserParameter=mmysql.stat,/etc/zabbix/scripts/mysql_status.sh

                                            UserParameter=regis.time,/etc/zabbix/scripts/ms_time.sh

                                            UserParameter=trunk.down,/etc/zabbix/scripts/trunk_down.sh

                                            UserParameter=worng.pass,/etc/zabbix/scripts/worng_pass.sh

                                            UserParameter=call.graf,/etc/zabbix/scripts/graf_calls.sh

                                            UserParameter=failban.stat,/etc/zabbix/scripts/fail2ban_up.sh

                                            UserParameter=iptables.up,/etc/zabbix/scripts/iptables_status.sh

                                            UserParameter=ast.crash,/etc/zabbix/scripts/ast_crashes.sh" >> /etc/zabbix/zabbix_agentd.conf
                                        systemctl restart zabbix-agent
    fi
    