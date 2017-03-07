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
workdir='/root/menu/src'

clear
echo "Начинаю установку модуля расширенной статистики звонков"
cd /tmp
wget ftp://ftp:Profesora448912@46.72.255.6/asternic_cdr-1.6.3.tgz
tar -zxvf asternic_cdr-1.6.3.tgz
cp -R asternic_cdr /var/www/html/admin/modules/
fwconsole chown
fwconsole moduleadmin install asternic_cdr
fwconsole reload
br
echo "Модуль установлен и активирован, в веб интерфейсе freepbx Вкладка reports"
sleep 2
br
waitend