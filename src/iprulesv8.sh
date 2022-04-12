#!/bin/bash
#iptables rule set with geoip rules and raw table.
#Supported only centos7.x
#maybe work on 6.x but i don't shure about that.
domain=`hostname`
end()
{
echo -e "Press any key"
read -s -n 1
}

ipsave()
{
service iptables save
systemctl start iptables
}

myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]]
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}

echo -e "\nPress enter sip port, or port range.Example range 5060:5061 or one single port 5060"
read sipport ;
echo -e "\nPress enter your local network subnet 192.168.0.0/24"
read localnet ;
echo -e "\nPress enter country code to except, example RU,LV,US without spaces"
read country ;
#turn off iptables to safe you
systemctl stop iptables
iptables -F
###iptables main rules###
#iptables Policy
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
#iptables chains
iptables -N SSHC
iptables -N SIPACL
iptables -N IWL
#iptables IWL
iptables -I IWL -s 176.192.230.26 -j ACCEPT
iptables -I IWL -s $localnet -j ACCEPT
iptables -A IWL -j RETURN
#iptables SSHC
iptables -I SSHC -j IWL
iptables -A SSHC -m state --state NEW -m hashlimit --hashlimit-above 5/min --hashlimit-burst 5 --hashlimit-mode srcip --hashlimit-name SSH -j REJECT --reject-with icmp-port-unreachable
iptables -A SSHC -m state --state NEW -j ACCEPT
iptables -A SSHC -j RETURN
#iptables INPUT
iptables -I INPUT 1 -m conntrack --ctstate INVALID -j DROP
iptables -I INPUT 2 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j SSHC
iptables -A INPUT -p tcp -m multiport --dports 8077,8078 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 9980 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 10150 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 5060:5160 -j SIPACL
iptables -A INPUT -i lo -j ACCEPT
IPTABLES -A INPUT -m state —state RELATED,ESTABLISHED -j ACCEPT
IPTABLES -A INPUT -m state —state INVALID -j DROP
IPTABLES -A INPUT -p tcp -m state —state NEW —tcp-flags SYN,ACK SYN,ACK -j REJECT —reject-with tcp-reset
IPTABLES -A INPUT -p tcp -m state —state NEW! —syn -j DROP
iptables -A INPUT -m geoip ! --source-country $country -j DROP
iptables -A INPUT -j DROP
#iptables OUTPUT
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -m state —state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j DROP
iptables -A OUTPUT -f -j DROP
#iptables SIPACL
iptables -I SIPACL -j IWL
iptables -I SIPACL -m recent --set --name SIPALLOW --mask 255.255.255.255 --rsource -j ACCEPT
iptables -I SIPACL -m geoip ! --source-country $country -j DROP
###iptables RAW rules###
#iptables chains
iptables -t raw -N WL
iptables -t raw -N SIP
iptables -t raw -N SIPA
iptables -t raw -N SIPB
iptables -t raw -N BADASS
#iptables prerouting
iptables -t raw -I prerouting -j BADASS
iptables -t raw -I prerouting -i eth+ -m recent --update --name SIPBLOCK --mask 255.255.255.255 --rsource -j DROP
iptables -t raw -I prerouting -i eth+ -m recent --update --name SIPALLOW --mask 255.255.255.255 --rsource -j ACCEPT
iptables -t raw -I prerouting -p udp -m udp --dport 5060 -m string --algo bm --string "INVITE sip:" -j SIP
iptables -t raw -I prerouting -p udp -m udp --dport 5060 -m string --algo bm --string "REGISTER sip:" -j SIP
iptables -t raw -I prerouting -i eth+ -p udp -m udp --dport 5060:5160 -j SIP
#iptables -t raw BADASS
iptables -t raw -A BADASS -j RETURN 
#iptables -t raw SIPB
iptables -t raw -I SIPB -m recent --set --name SIPBLOCK --mask 255.255.255.255 --rsource -j DROP
#iptables -t raw SIPA
iptables -t raw -I SIPA -m recent --set --name SIPALLOW --mask 255.255.255.255 --rsource -j ACCEPT
#iptables -t raw WL
iptables -t raw -I WL -s $localnet -j ACCEPT
iptables -t raw -I WL -s 176.192.230.26 -j ACCEPT
iptables -t raw -A WL -j RETURN
#iptables -t raw SIP
iptables -t raw -I SIP -j WL
iptables -t raw -A SIP -i eth+ -p udp -m udp --dport $sipport -m string --string "$domain" --algo bm --icase -j SIPA
iptables -t raw -A SIP -m string --string "sundayddr" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "sipsak" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "sipvicious" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "friendly-scanner" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "iWar" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "sip-scan" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "sipcli" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "eyeBeam" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "friendly-request" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "smap" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "FPBX" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "Zfree" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "Z 3.14.38765 rv2.8.3" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "sipcli/v1.8" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "PBX" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "Wildix GW 20200131.2~1d78401d" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "AGFEO SIP V3.00.15 b" --algo bm -j SIPB
iptables -t raw -A SIP -m string --string "pplsip" --algo bm -j SIPB
ipsave
end