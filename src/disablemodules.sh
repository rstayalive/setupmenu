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
fwconsole ma uninstall areminder
fwconsole ma uninstall broadcast
fwconsole ma uninstall callerid
fwconsole ma uninstall calllimit
fwconsole ma uninstall conferencespro
fwconsole ma uninstall configedit
fwconsole ma uninstall contactmanager
fwconsole ma uninstall cos
fwconsole ma uninstall cxpanel
fwconsole ma uninstall dahdiconfig
fwconsole ma uninstall daynight
fwconsole ma uninstall dictate
fwconsole ma uninstall digium_phones
fwconsole ma uninstall digiumaddoninstaller
fwconsole ma uninstall directory
fwconsole ma uninstall disa
fwconsole ma uninstall dundicheck
fwconsole ma uninstall extensionroutes
fwconsole ma uninstall endpoint
fwconsole ma uninstall fax
fwconsole ma uninstall faxpro
fwconsole ma uninstall freepbx_ha
fwconsole ma uninstall hotelwakeup
fwconsole ma uninstall irc
fwconsole ma uninstall iotserver
fwconsole ma uninstall motif
fwconsole ma uninstall pagingpro
fwconsole ma uninstall parkpro
fwconsole ma uninstall pbdirectory
fwconsole ma uninstall pinsetspro
fwconsole ma uninstall queuestats
fwconsole ma uninstall recording_report
fwconsole ma uninstall restapps
fwconsole ma uninstall sangomacrm
fwconsole ma uninstall sipstation
fwconsole ma uninstall sms
fwconsole ma uninstall tts
fwconsole ma uninstall ttsengines
fwconsole ma uninstall vmnotify
fwconsole ma uninstall voicemail_report
fwconsole ma uninstall vqplus
fwconsole ma uninstall webcallback
fwconsole ma uninstall webrtc
fwconsole ma uninstall xmpp
fwconsole ma uninstall zulu
fwconsole ma uninstall pms
fwconsole ma uninstall qxact_reports
fwconsole ma uninstall vega
fwconsole ma uninstall pbxmfa
fwconsole ma uninstall smsplus
fwconsole ma uninstall sms
fwconsole ma uninstall ucpnode
fwconsole ma uninstall ucp
fwconsole ma uninstall vqplus
fwconsole ma uninstall missedcall
fwconsole ma uninstall superfecta 
fwconsole ma uninstall presencestate
fwconsole ma uninstall vmblast
fwconsole ma uninstall phonebook
fwconsole ma uninstall missedcall
fwconsole ma uninstall donotdisturb
fwconsole ma uninstall cidlookup
fwconsole ma uninstall callback
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
fwconsole ma remove sangomaconnect
fwconsole ma remove pbxmfa
fwconsole ma remove smsplus
fwconsole ma remove sms
fwconsole ma remove ucp
fwconsole ma remove callaccounting
fwconsole ma remove cos
fwconsole ma remove oracle_connector
fwconsole ma remove pms
fwconsole ma remove iotserver
fwconsole ma remove queuemetrics
fwconsole ma remove sng_mcu
} &> /dev/null
echo "Removing modules.Stage $count2 of 3"
count2=$(( $count2 + 1 ))
done
echo "Modules removed"
fwconsole reload > /dev/null 2>&1
waitend
