#!/bin/bash
#freepbx additional settings configure

#setting timezone to ru
fwconsole setting TONEZONE ru -n
#call waiting set to be disabled
fwconsole setting ENABLECW 0 -n
#apply config after modules updated automaticaly
fwconsole setting AUTOMODULEUPDATESANDRELOAD 1 -n
#disabling browser stats for best perfomance
fwconsole setting BROWSER_STATS 0 -n
#set time formart from 12 to 24 hour
fwconsole setting TIMEFORMAT 24 Hour Format -n
#set rss feed to telephonization.ru
fwconsole setting RSSFEEDS https://telephonization.ru/rss-feed-616647289231.xml -n
#adding your IP to firewall as trusted
read -p "Please enter your IP address or network. Example 192.168.0.0/24 or 192.168.0.50: " IPnet

#cheking firewall module installed and enabled
FWM=$(fwconsole ma list | grep "firewall" | grep "Enabled")
if [ "$FWM" == "Enabled" ]; then
    echo "enabled"
    fwconsole firewall add trusted $IPnet
    fwconsole firewall add trusted 193.33.231.194
    fwconsole firewall add trusted 176.192.230.26
    fwconsole firewall lerules enable
    fwconsole firewall sync
    fwconsole firewall restart
else
    echo "disabled:"
    fwconsole ma downloadinstall firewall
    fwconsole ma enable firewall
    echo "firewall installed and enabled. Now adding exeptions"
    fwconsole firewall add trusted $IPnet
    fwconsole firewall add trusted 176.192.230.26 
    fwconsole firewall add trusted 193.33.231.194
    fwconsole firewall lerules enable
    fwconsole firewall sync
    fwconsole firewall restart
fi