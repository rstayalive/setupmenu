#!/bin/bash
#Скрипт установки zabbix agent
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
#end
end()
{
echo -e "$GREДля продолжения нажмите любую клавишу $DEF"
read -s -n 1
}
workdir='/root/setupmenu/src'
hostn=`hostname`
system=$(grep -oE '[0-9]+\.' /etc/redhat-release | cut -f1 -d".")
zabi=$(rpm -qa | grep zabbix-agent)
arc=`arch`

if grep -F 'zabbix' /etc/passwd | cut -f1 -d":" ;
    then
    echo "zabbix уже существует, пропускаю..."
    else
    /usr/sbin/groupadd zabbix
    /usr/sbin/useradd -g zabbix zabbix
    echo "Добавили группу zabbix и пользователя zabbix"
fi
#Проверяем не стоит ли уже zabbix-agent
if [ "" == "$zabi" ];
    then
    echo "Начинаю установку"
    #проверяем версию системы
        if [[ "$system" == "6" && "$arc" == "x86_64" ]];
            then
            rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-agent-3.4.1-1.el6.x86_64.rpm
            else
                if [[ "$system" == "7" && "$arc" == "x86_64" ]];
                    then
                    rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.1-1.el7.x86_64.rpm
                    else
                    cd /tmp
                    cp $workdir/zabbix-3.4.1.tar.gz /tmp
                    tar -zxvf /tmp/zabbix-3.4.1.tar.gz
                    cd /tmp/zabbix-3.4.1
                    bash configure --enable-agent
                    make install
                    #Удаляем дефолтный конфиг, подкидываем свой настроенный конфиг.
                    rm -rvf /usr/local/etc/zabbix_agentd.conf
                    cp $workdir/zabbix_agentd.conf /usr/local/etc/zabbix_agentd.conf
                        if [ "$hostn" == "localhost.localdomain" ];
                            then
                            echo -e "\nВведите hostname сервера"
                            read host;
                            replace "Hostname=" "Hostname=$host" -- /usr/local/etc/zabbix_agentd.conf
                            echo "Внесли $host в конфиг файл zabbix agent"
                            else
                            echo "Вношу hostname $hostn в конфиг zabbix"
                            replace "Hostname=" "Hostname=$hostn" -- /usr/local/etc/zabbix_agentd.conf
                        fi
                fi
                else
    echo "Zabbix agent установлен!"
        if
    fi
groupadd zabbix
useradd -g zabbix zabbix
/etc/init.d/zabbix_agentd
end