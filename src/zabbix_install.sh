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
system7=$(grep -oE '[0-9]+\.[0-9]+\.' /etc/redhat-release | cut -f1 -d".")
zabi=$(rpm -qa | grep zabbix-agent)
arc=`arch`
#Y/N
myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]] #запрашиваем значение, пока не будет "y" или "n"
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}

if grep -F 'zabbix' /etc/passwd | cut -f1 -d":" ;
    then
    echo "user zabbix уже существует, пропускаю..."
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
            echo "ставим версию для redhat $system и разрядности $arch"
            rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-agent-3.4.1-1.el6.x86_64.rpm
            cp $workdir/zabbix_agentd.conf /etc/zabbix/
            if [ "$hostn" == "localhost.localdomain" ];
                then
                echo -e "\nВведите hostname сервера"
                read host;
                replace "Hostname=" "Hostname=$host" -- /etc/zabbix/zabbix_agentd.conf
                echo "Внесли $host в конфиг файл zabbix agent"
                else
                echo "Вношу hostname $hostn в конфиг zabbix"
                replace "Hostname=" "Hostname=$hostn" -- /etc/zabbix/zabbix_agentd.conf
            fi
            else
                if [[ "$system7" == "7" && "$arc" == "x86_64" ]];
                    then
                    echo "ставим версию для redhat $system и разрядности $arch"
                    rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.1-1.el7.x86_64.rpm
                    cp $workdir/zabbix_agentd.conf /etc/zabbix/
                        if [ "$hostn" == "localhost.localdomain" ];
                            then
                            echo -e "\nВведите hostname сервера"
                            read host;
                            replace "Hostname=" "Hostname=$host" -- /etc/zabbix/zabbix_agentd.conf
                            echo "Внесли $host в конфиг файл zabbix agent"
                            else
                            echo "Вношу hostname $hostn в конфиг zabbix"
                            replace "Hostname=" "Hostname=$hostn" -- /etc/zabbix/zabbix_agentd.conf
                        fi
                    else
                    echo "Для вашей системы нет подготовленного пакета!"
                    echo -e "$GREУстновить из исходных кодов? Y/N$DEF"
                    myread_yn zabinst
                    case "$zabinst" in
                    y|Y)
                    echo -e "Начинаю установку Zabbix agent из исходных кодов!"
                    cd /tmp
                    cp $workdir/zabbix-3.4.1.tar.gz /tmp
                    tar -zxvf /tmp/zabbix-3.4.1.tar.gz
                    cd /tmp/zabbix-3.4.1
                    bash configure --enable-agent
                    make install
                    rm -rvf /usr/local/etc/zabbix_agentd.conf
                    cp $workdir/zabbix_agentd.conf_src /usr/local/etc/zabbix_agentd.conf
                    cp /tmp/zabbix-3.4.1/src/zabbix_agent/zabbix_agentd /etc/init.d/
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
                    echo "Готово" ;;
                    n|N)
                    echo "выходим" ;;
                    esac
                fi
        fi
    else
    echo "Zabbix agent установлен!"
fi

groupadd zabbix
useradd -g zabbix zabbix
end