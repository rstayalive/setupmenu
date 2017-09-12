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
cd /tmp
cp $workdir/zabbix-3.4.1.tar.gz /tmp
#Проверяем есть пользователь zabbix в системе или нет, если нет его, тогда добавляем
if grep -F 'zabbix' /etc/passwd | cut -f1 -d":" &> /dev/null ;
then
echo "zabbix уже существует, пропускаю..."
else
/usr/sbin/groupadd zabbix
/usr/sbin/useradd -g zabbix zabbix
fi
#начинаем установку
tar -zxvf /tmp/zabbix-3.4.1.tar.gz
bash configure --enable-agent
make install
#Создаем лог файл, а то будет ругаться.
touch /var/log/zabbix_agentd.log
chown zabbix:zabbix /var/log/zabbix_agentd.log
#Удаляем дефолтный конфиг, подкидываем свой настроенный конфиг.
rm -rvf /usr/local/etc/zabbix_agentd.conf
cp $workdir/zabbix_agentd.conf /usr/local/etc/zabbix_agentd.conf
if [ "$domain" == "localhost.localdomain" ];
then
echo -e "\nВведите hostname сервера"
read host;
replace "Hostname=" "Hostname=$host" -- /usr/local/etc/zabbix_agentd.conf
zabbix_agentd
else
echo "Вношу hostname $hostn в конфиг zabbix"
replace "Hostname=" "Hostname=$hostn" -- /usr/local/etc/zabbix_agentd.conf
zabbix_agentd
fi
echo "Готово"
end