#!/bin/bash
#this script manage unused fpbx modules
waitend()
{
echo "Press any key to continue"
read -s -n 1
}
echo "Job started.Please wait."
count=1
while [ $count -le 2 ]
do
{
fwconsole ma uninstall adv_recovery
fwconsole ma uninstall areminder
fwconsole ma uninstall broadcast
fwconsole ma uninstall callaccounting
fwconsole ma uninstall callerid
fwconsole ma uninstall calllimit
fwconsole ma uninstall conferencespro
fwconsole ma uninstall contactmanager
fwconsole ma uninstall cos
fwconsole ma uninstall cxpanel
fwconsole ma uninstall dahdiconfig
fwconsole ma uninstall dictate
fwconsole ma uninstall directory
fwconsole ma uninstall disa
fwconsole ma uninstall endpoint
fwconsole ma uninstall extensionroutes
fwconsole ma uninstall fax
fwconsole ma uninstall faxpro
fwconsole ma uninstall hotelwakeup
fwconsole ma uninstall iotserver
fwconsole ma uninstall irc
fwconsole ma uninstall oracle_connector
fwconsole ma uninstall pagingpro
fwconsole ma uninstall parkpro
fwconsole ma uninstall pinsetspro
fwconsole ma uninstall pms
fwconsole ma uninstall queueprio
fwconsole ma uninstall queuestats
fwconsole ma uninstall qxact_reports
fwconsole ma uninstall recording_report
fwconsole ma uninstall restapps
fwconsole ma uninstall sangomaconnect
fwconsole ma uninstall sangomacrm
fwconsole ma uninstall sangomartapi
fwconsole ma uninstall sipstation
fwconsole ma uninstall smsplus
fwconsole ma uninstall sms
fwconsole ma uninstall pbxmfa
fwconsole ma uninstall tts
fwconsole ma uninstall ttsengines
fwconsole ma uninstall ucp
fwconsole ma uninstall missedcall
fwconsole ma uninstall vega
fwconsole ma uninstall vmnotify
fwconsole ma uninstall voicemail_report
fwconsole ma uninstall voipinnovations
fwconsole ma uninstall vqplus
fwconsole ma uninstall webcallback
fwconsole ma uninstall webrtc
fwconsole ma uninstall xmpp
fwconsole ma uninstall zulu
} &> /dev/null
echo "Uninstalling modules.Stage $count of 2"
count=$(( $count + 1 ))
done
echo "Unused modules uninstalled"
#disabling modules may be needed
echo "Disabling maybe needed modules"
fwconsole ma uninstall configedit
echo "Done."
echo "Next job - Removing modules from hdd"
count2=1
while [ $count2 -le 2 ]
do
{
fwconsole ma remove adv_recovery
fwconsole ma remove areminder
fwconsole ma remove broadcast
fwconsole ma remove callaccounting
fwconsole ma remove callerid
fwconsole ma remove calllimit
fwconsole ma remove conferencespro
fwconsole ma remove contactmanager
fwconsole ma remove cos
fwconsole ma remove cxpanel
fwconsole ma remove dahdiconfig
fwconsole ma remove dictate
fwconsole ma remove directory
fwconsole ma remove disa
fwconsole ma remove endpoint
fwconsole ma remove extensionroutes
fwconsole ma remove fax
fwconsole ma remove faxpro
fwconsole ma remove hotelwakeup
fwconsole ma remove iotserver
fwconsole ma remove irc
fwconsole ma remove oracle_connector
fwconsole ma remove pagingpro
fwconsole ma remove parkpro
fwconsole ma remove pinsetspro
fwconsole ma remove pms
fwconsole ma remove queueprio
fwconsole ma remove queuestats
fwconsole ma remove qxact_reports
fwconsole ma remove recording_report
fwconsole ma remove restapps
fwconsole ma remove sangomaconnect
fwconsole ma remove sangomacrm
fwconsole ma remove sangomartapi
fwconsole ma remove sipstation
fwconsole ma remove sms
fwconsole ma remove tts
fwconsole ma remove ttsengines
fwconsole ma remove ucp
fwconsole ma remove vega
fwconsole ma remove vmnotify
fwconsole ma remove voicemail_report
fwconsole ma remove voipinnovations
fwconsole ma remove vqplus
fwconsole ma remove webcallback
fwconsole ma remove webrtc
fwconsole ma remove xmpp
fwconsole ma remove zulu
fwconsole ma remove sng_mcu
} &> /dev/null
echo "Removing modules.Stage $count2 of 2"
count2=$(( $count2 + 1 ))
done
echo "Modules removed"
fwconsole reload > /dev/null 2>&1
waitend


