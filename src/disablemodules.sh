#!/bin/bash
# This script for disabling/removing not used FPBX modules.
waitend()
{
echo "Press any key to continue"
read -s -n 1
}
echo "Job started.Please wait."
count=1
while [ $count -le 3 ]
do
{
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
fwconsole ma disable extensionroutes
fwconsole ma disable endpoint
fwconsole ma disable fax
fwconsole ma disable faxpro
fwconsole ma disable freepbx_ha
fwconsole ma disable hotelwakeup
fwconsole ma disable irc
fwconsole ma disable iotserver
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
fwconsole ma disable ucpnode
fwconsole ma disable ucp
fwconsole ma disable vqplus
} &> /dev/null
echo "Disablig modules.Stage $count of 3"
count=$(( $count + 1 ))
done
echo "Modules disabled"

echo "Next job - Removing modules"
count2=1
while [ $count2 -le 3 ]
do
{
fwconsole ma remove disa
fwconsole ma remove dictate
fwconsole ma remove digiumaddoninstaller
fwconsole ma remove fax
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
} &> /dev/null
echo "Removing modules.Stage $count2 of 3"
count2=$(( $count2 + 1 ))
done
echo "Modules removed"
fwconole reload > /dev/null 2>&1
waitend
