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
		fwconsole moduleadmin disable bria
		fwconsole moduleadmin disable broadcast
		fwconsole moduleadmin disable bulkdids
		fwconsole moduleadmin disable callerid
		fwconsole moduleadmin disable calllimit
		fwconsole moduleadmin disable conferencespro
		fwconsole moduleadmin disable dahdiconfig
		fwconsole moduleadmin disable cxpanel
		fwconsole moduleadmin disable digium_phones
		fwconsole moduleadmin disable freepbx_ha
		fwconsole moduleadmin disable irc
		fwconsole moduleadmin disable pagingpro
		fwconsole moduleadmin disable parkpro
		fwconsole moduleadmin disable pinsetspro
		fwconsole moduleadmin disable recording_report
		fwconsole moduleadmin disable restapps
		fwconsole moduleadmin disable sipstation
		fwconsole moduleadmin disable sng_mcu
		fwconsole moduleadmin disable ucpnode
		fwconsole moduleadmin disable vqplus
		fwconsole moduleadmin disable xmpp
		fwconsole moduleadmin disable sangomacrm
		fwconsole moduleadmin disable zulu
		fwconsole moduleadmin disable rmsadmin
		fwconsole moduleadmin disable webcallback
		fwconsole moduleadmin disable voicemail_report
		fwconsole moduleadmin disable vmnotify
		fwconsole moduleadmin disable faxpro
		fwconsole moduleadmin disable cos
        fwconsole moduleadmin disable endpoint
        fwconsole moduleadmin disable reminder
		echo "Модули успешно отключены"
		fwconsole reload
waitend