#!/bin/bash
# Установить Модуль расширенной статистики звонков asternic

#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

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
workdir='/root/setupmenu/src'

clear
echo "Начинаю установку модуля расширенной статистики звонков"
#cp $workdir/asternic_cdr-1.6.3.tgz /tmp
cd /tmp
wget http://download.asternic.net/asternic_cdr-1.6.4.tgz
tar -zxvf asternic_cdr-1.6.4.tgz
cp -R asternic_cdr /var/www/html/admin/modules/
fwconsole chown
fwconsole moduleadmin install asternic_cdr
fwconsole reload
rm -rf /tmp/asternic*
echo "Модуль установлен и активирован, в веб интерфейсе freepbx Вкладка reports"
sleep 2
waitend