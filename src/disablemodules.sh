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
    fwconsole ma disable areminder
    fwconsole ma disable broadcast
    fwconsole ma disable callerid
    fwconsole ma disable calllimit
    fwconsole ma disable conferencespro
    fwconsole ma disable configedit
    fwconsole ma disable contactmanager
    fwconsole ma disable cos
    fwconsole ma disable customappsreg
    fwconsole ma disable cxpanel
    fwconsole ma disable dahdiconfig
    fwconsole ma disable daynight
    fwconsole ma disable dictate
    fwconsole ma disable digium_phones
    fwconsole ma disable digiumaddoninstaller
    fwconsole ma disable directory
    fwconsole ma disable disa
    fwconsole ma disable dundicheck
    fwconsole ma disable endpoint
    fwconsole ma disable fax
    fwconsole ma disable faxpro
    fwconsole ma disable freepbx_ha
    fwconsole ma disable hotelwakeup
    fwconsole ma disable irc
    fwconsole ma disable motif
    fwconsole ma disable pagingpro
    fwconsole ma disable parkpro
    fwconsole ma disable pbdirectory
    fwconsole ma disable pinsetspro
    fwconsole ma disable queuestats
    fwconsole ma disable recording_report
    fwconsole ma disable restapps
    fwconsole ma disable sangomacrm
    fwconsole ma disable sipstation
    fwconsole ma disable sms
    fwconsole ma disable tts
    fwconsole ma disable ttsengines
    fwconsole ma disable vmnotify
    fwconsole ma disable voicemail_report
    fwconsole ma disable vqplus
    fwconsole ma disable webcallback
    fwconsole ma disable webrtc
    fwconsole ma disable xmpp
    fwconsole ma disable zulu
    fwconsole ma disable pms
    fwconsole ma disable qxact_reports
    fwconsole ma disable vega
 echo "Модули успешно отключены"
    fwconsole reload
echo "Начинаю удаление модулей"    
    fwconsole ma remove disa
    fwconsole ma remove endpoint
    fwconsole ma remove extensionroutes
    fwconsole ma remove faxpro
    fwconsole ma remove freepbx_ha
    fwconsole ma remove pagingpro
    fwconsole ma remove parkpro
    fwconsole ma remove pinsetspro
    fwconsole ma remove queuestats
    fwconsole ma remove qxact_reports
    fwconsole ma remove recording_report
    fwconsole ma remove restapps
    fwconsole ma remove sangomacrm
    fwconsole ma remove sipstation
    fwconsole ma remove sms
    fwconsole ma remove tts
    fwconsole ma remove ttsengines
    fwconsole ma remove vega
    fwconsole ma remove vmnotify
    fwconsole ma remove voicemail_report
    fwconsole ma remove vqplus
    fwconsole ma remove webcallback
    fwconsole ma remove webrtc
    fwconsole ma remove xmpp
    fwconsole ma remove zulu
    fwconsole ma remove areminder
    fwconsole ma remove broadcast
    fwconsole ma remove callerid
    fwconsole ma remove calllimit
    fwconsole ma remove conferencespro
    fwconsole ma remove configedit
    fwconsole ma remove contactmanager
    fwconsole ma remove cos
    fwconsole ma remove customappsreg
    fwconsole ma remove cxpanel
    fwconsole ma remove dahdiconfig
    fwconsole ma remove daynight
    fwconsole ma remove directory
    fwconsole ma remove digium_phones
    fwconsole ma remove dundicheck
    fwconsole ma remove hotelwakeup
    fwconsole ma remove irc
    fwconsole ma remove motif
    fwconsole ma remove pbdirectory
    fwconsole ma disable ucp
    fwconsole reload
 echo "готово"
waitend