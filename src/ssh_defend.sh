#!/bin/bash
#Скрипт защиты ssh через hosts.allow/deny
ALLOW_COUNTRIES="strana"
LOGDENY_FACILITY="authpriv.notice"
if [[ "`echo $1 | grep ':'`" != "" ]] ; then
  COUNTRY=`/usr/bin/geoiplookup6 "$1" | awk -F ": " '{ print $2 }' | awk -F "," '{ print $1 }' | head -n 1`
else
  COUNTRY=`/usr/bin/geoiplookup "$1" | awk -F ": " '{ print $2 }' | awk -F "," '{ print $1 }' | head -n 1`
fi
[[ $COUNTRY = "IP Address not found" || $ALLOW_COUNTRIES =~ $COUNTRY ]] && RESPONSE="ALLOW" || RESPONSE="DENY"
if [[ "$RESPONSE" == "ALLOW" ]] ; then
  exit 0
else
  logger -p $LOGDENY_FACILITY "$RESPONSE sshd connection from $1 ($COUNTRY)"
  exit 1
fi