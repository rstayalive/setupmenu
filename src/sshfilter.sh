#!/bin/bash
# based on script from http://www.axllent.org/docs/view/ssh-geoip
# License: WTFPL

#
### expects geoip package and a cronjob to keep the geoip db up2date
### expects hosts.deny and hosts.allow to set up correctly aka https://tecadmin.net/allow-server-access-based-on-country/
#

## Usage example: /etc/hosts.allow
# Default country list:
#  sshd: ALL : spawn /usr/local/bin/sshfilter %a %d
# Custom country list:
#  sshd: ALL : spawn /usr/local/bin/sshfilter %a %d "DE US" [<iptables chain>]

## iptables extension
# it's recommended to use a dedicated chain, created with
#	iptables -A INPUT -j BLOCKDYN
# 	ip6tables -A INPUT -j BLOCKDYN

## Testing
# to stdout:
#	/path/to/sshfilter.sh 1.2.3.4 ssh DE BLOCKDYN
# to syslog
#	echo "" | /path/to/sshfilter.sh 1.2.3.4 ssh DE BLOCKDYN
# resulting in following
# 	iptables -nL BLOCKDYN
# 	Chain BLOCKDYN (1 references)
# 	target     prot opt source               destination
# 	DROP       all  --  1.2.3.4              0.0.0.0/0            /* 2018-07-21T06:27:32+0000 ssh: ipfilter.sh */

## Changelog


# Web Feb 06 initial mods to run on SME
# Further modified for Koozali SME server

# 20180721/pbiering: extend syslog, proper iptables selection for IPv6 and custom iptables chain

## TODO
# provide script for regular cleanup of iptables chain by checking inserted timestamp
# add support for firewalld


# UPPERCASE space-separated country codes to ACCEPT
#ALLOW_COUNTRIES="UK ES" # <- your potential default list
ALLOW_COUNTRIES="${ALLOW_COUNTRIES:-strana}" # default if empty
# This will log to /var/log/secure
LOGDENY_FACILITY="authpriv.info"
# This should go to /var/log/messages but doesn't. Need to figure that out
LOGDENY_FACILITY_ERR="authpriv.error"
CHAIN="BLOCKDYN"

logtag="$(basename $0)"
if [ -n "$2" ]; then
	logtag="$2: $logtag"
fi

if [ $# -lt 2 -o $# -gt 4 ]; then
  echo "Usage:  `basename $0` <ip> <daemon name> [country list] [<iptables chain>]" 1>&2
  exit 0 # return true in case of config issue
fi

if [ -n "$3" ]; then
	ALLOW_COUNTRIES="$3"
fi

if [ -n "$4" ]; then
	CHAIN="$4"
fi

if [[ $1 =~ : ]] ; then
  IPTABLES="$(which ip6tables)"
  GEOIPLOOKUP="$(which geoiplookup6)"
else
  IPTABLES="$(which iptables)"
  GEOIPLOOKUP="$(which geoiplookup)"
fi

if [ -z "$GEOIPLOOKUP" ]; then
  echo "$GEOIPLOOKUP not found - please install it via your package manager!"
  exit 0
fi

if [ ! -x "$GEOIPLOOKUP" ]; then
  [ -t 0 ] || logger -t "$logtag" -p $LOGDENY_FACILITY_ERROR "not executable: $GEOIPLOOKUP"
  [ -t 0 ] && echo "missing executable: $GEOIPLOOKUP"
  exit 0
fi

if [ -n "$CHAIN" -a -z "$IPTABLES" ]; then
  echo "$IPTABLES not found - please install it via your package manager (disable appending IP to block in chain $CHAIN)!"
  CHAIN=""
fi

if [ -n "$CHAIN" -a ! -x "$IPTABLES" ]; then
  [ -t 0 ] || logger -t "$logtag" -p $LOGDENY_FACILITY_ERROR "not executable: $IPTABLES"
  [ -t 0 ] && echo "missing executable: $IPTABLES"
  exit 0
fi

COUNTRY=`$GEOIPLOOKUP "$1" | awk -F ": " '{ print $2 }' | awk -F "," '{ print $1 }' | head -n 1`
[[ $COUNTRY = "IP Address not found" || $ALLOW_COUNTRIES =~ $COUNTRY ]] && RESPONSE="ALLOW" || RESPONSE="DENY"

if [[ "$RESPONSE" == "ALLOW" ]] ; then
  [ -t 0 ] || logger -t "$logtag" -p $LOGDENY_FACILITY "$RESPONSE $2 connection from $1 ($COUNTRY)"
  [ -t 0 ] && echo "$RESPONSE $2 connection from $1 ($COUNTRY)"
  exit 0
else
  [ -t 0 ] || logger -t "$logtag" -p $LOGDENY_FACILITY "$RESPONSE $2 connection from $1 ($COUNTRY)"
  [ -t 0 ] && echo "$RESPONSE $2 connection from $1 ($COUNTRY)"

  if [ -n "$CHAIN" ]; then
    # create comment for iptables
    COMMENT="$(/bin/date -u -Iseconds)"
    # add iptables rule because it's not working without
    OUTPUT=$($IPTABLES -I $CHAIN 1 -s $1 -j DROP -m comment --comment "$COMMENT $logtag" 2>&1)
    
    [ -t 0 ] || logger -t "$logtag" -p $LOGDENY_FACILITY_ERROR "This is the OUTPUT: $OUTPUT"
    
    if [ $? -ne 0 ]; then
      [ -t 0 ] || logger -t "$logtag" -p $LOGDENY_FACILITY_ERROR "command is not working: $OUTPUT"
      [ -t 0 ] && echo "$IPTABLES is not working: $OUTPUT"
    fi
  fi

  exit 1
fi
