#!/bin/bash
# Настройка автоматического обновления системы
#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

myinstall()
{
if [ -z `rpm -qa $1` ]; then
	yum -y install $1
else
	echo "Пакет $1 уже установлен"
	br
fi
}

wait()
{
echo -e "$GRE Нажмите любую клавишу $DEF"
read -s -n 1
}

waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

#Начало работы
echo "Настравиваю автообновление системы"
myinstall yum-cron
chkconfig yum-cron on
service yum-cron start
service crond restart
echo "Все настроено, все демоны настроены"
waitend