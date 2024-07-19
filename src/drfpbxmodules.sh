#!/bin/bash

# This script disables and removes unused FreePBX modules

waitend() {
    echo "Press any key to continue"
    read -s -n 1
}

log_file="/var/log/freepbx_module_cleanup.log"
timestamp=$(date +'%Y-%m-%d %H:%M:%S')

log() {
    echo "[$timestamp] $1" >> "$log_file"
}

uninstall_modules=(
    areminder broadcast callerid calllimit conferencespro configedit
    contactmanager cos cxpanel dahdiconfig daynight dictate
    digium_phones digiumaddoninstaller directory disa dundicheck
    extensionroutes endpoint fax faxpro freepbx_ha hotelwakeup irc
    iotserver motif pagingpro parkpro pbdirectory pinsetspro queuestats
    recording_report restapps sangomacrm sipstation sms tts ttsengines
    vmnotify voicemail_report vqplus webcallback webrtc xmpp zulu pms
    qxact_reports vega pbxmfa smsplus ucpnode ucp missedcall superfecta
    presencestate vmblast phonebook donotdisturb cidlookup callback
    sangomaconnect callaccounting oracle_connector queuemetrics sng_mcu
)

remove_modules=(
    disa dictate digiumaddoninstaller fax endpoint extensionroutes faxpro
    freepbx_ha pagingpro parkpro pinsetspro queuestats qxact_reports
    recording_report restapps sangomacrm sipstation sms tts ttsengines
    vega vmnotify voicemail_report vqplus webcallback webrtc xmpp zulu
    areminder broadcast callerid calllimit conferencespro
    contactmanager cos cxpanel dahdiconfig daynight directory digium_phones
    dundicheck hotelwakeup irc motif pbdirectory sangomaconnect pbxmfa
    smsplus ucp callaccounting cos oracle_connector pms iotserver
    queuemetrics sng_mcu
)

echo "Job started. Please wait."

uninstall_modules() {
    for module in "${uninstall_modules[@]}"; do
        fwconsole ma uninstall "$module" &> /dev/null
        if [ $? -eq 0 ]; then
            log "Successfully uninstalled module: $module"
        else
            log "Failed to uninstall module: $module"
        fi
    done
}

remove_modules() {
    for module in "${remove_modules[@]}"; do
        fwconsole ma remove "$module" &> /dev/null
        if [ $? -eq 0 ]; then
            log "Successfully removed module: $module"
        else
            log "Failed to remove module: $module"
        fi
    done
}

# Uninstall and remove modules in stages
for stage in {1..3}; do
    echo "Disabling modules. Stage $stage of 3"
    uninstall_modules
    echo "Removing modules. Stage $stage of 3"
    remove_modules
done

fwconsole reload &> /dev/null
echo "Modules disabled and removed. FreePBX reloaded."

waitend