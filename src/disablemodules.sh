#!/bin/bash
# Скрипт отключения неиспользуемых модулий FreePBX
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

#Начало работы
 echo "Отключаю модули"
    fwconsole moduleadmin disablebria
    fwconsole moduleadmin disablebroadcast
    fwconsole moduleadmin disablebulkdids
    fwconsole moduleadmin disablebulkextensions
    fwconsole moduleadmin disablecallerid
    fwconsole moduleadmin disablecalllimit
    fwconsole moduleadmin disableconferencespro
    fwconsole moduleadmin disablecxpanel
    fwconsole moduleadmin disabledahdiconfig
    fwconsole moduleadmin disabledigium_phones
    fwconsole moduleadmin disableendpoint
    fwconsole moduleadmin disablefaxpro
    fwconsole moduleadmin disablefreepbx_ha
    fwconsole moduleadmin disablepagingpro
    fwconsole moduleadmin disableparkpro
    fwconsole moduleadmin disablepinsetspro
    fwconsole moduleadmin disablerecording_report
    fwconsole moduleadmin disablerestapps
    fwconsole moduleadmin disablesangomacrm
    fwconsole moduleadmin disablesipstation
    fwconsole moduleadmin disableucpnode
    fwconsole moduleadmin disablevmnotify
    fwconsole moduleadmin disablevoicemail_report
    fwconsole moduleadmin disablevqplus
    fwconsole moduleadmin disablewebcallback
    fwconsole moduleadmin disablexmpp
    fwconsole moduleadmin disablezulu
    fwconsole moduleadmin disableirc
    fwconsole moduleadmin disablesng_mcu
    fwconsole moduleadmin disableucpnode
    fwconsole moduleadmin disablesangomacrm
    fwconsole moduleadmin disablermsadmin
    fwconsole moduleadmin disablevmnotify
    fwconsole moduleadmin disablecos
    fwconsole moduleadmin disablereminder
 echo "Модули успешно отключены"
    fwconsole reload
waitend