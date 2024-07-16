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
#adding our IP to firewall as trusted
fwconsole firewall add trusted 193.33.231.194
fwconsole firewall add trusted 176.192.230.26