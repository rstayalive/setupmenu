#!/bin/bash
#lets encrypt certificate setup
hname=`hostname`
read -p "enter your email for lets encrypt" mail
fwconsole cert --generate --type=letsencrypt --hostname=$hname --country-code=ru --state=moscow --email=$mail
fwconsole sysadmin ihc --set='$hname'