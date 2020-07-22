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

#Creating iptables Chains
iptables -P INPUT ACCEPT
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -N DEF
iptables -N ICMPF
iptables -N SIPACL
iptables -N SSHC
#INPUT rules
iptables -I INPUT 1 -p tcp --dport $sipport -m conntrack --ctstate RELATED,ESTABLISHED -m recent ! --rcheck --name MYSIP -j DROP
iptables -I INPUT 2 -m conntrack --ctstate INVALID -j DROP
iptables -I INPUT 3 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ICMPF
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j SSHC
iptables -A INPUT -p tcp -m multiport --dports 8077,8078 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 9980 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 7071 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 4569 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 10150 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
iptables -A INPUT -i eth+ -j DEF
iptables -A INPUT -s $localnet -j ACCEPT
iptables -A INPUT -s 176.192.230.26/32 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
iptables -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A INPUT -j SIPACL
iptables -A INPUT -m geoip ! --source-country RU,UA,IT  -j DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -j DROP
#OUTPUT rules
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -A OUTPUT -p tcp -m tcp --tcp-flags SYN,ACK SYN,ACK -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset
iptables -A OUTPUT -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j DROP
iptables -A OUTPUT -f -j DROP
#DEF CHAIN Filtering garbage
iptables -A DEF -m state --state INVALID -j DROP
iptables -A DEF -m state --state RELATED,ESTABLISHED -j ACCEPT
#optional rules. Enable if vps/vds.
#iptables -A DEF -s 10.0.0.0/8 -j DROP
#iptables -A DEF -s 172.16.0.0/12 -j DROP
#iptables -A DEF -s 192.168.0.0/16 -j DROP
#iptables -A DEF -s 0.0.0.0/8 -j DROP
#iptables -A DEF -s 100.64.0.0/10 -j DROP
#iptables -A DEF -s 127.0.0.0/8 -j DROP
#iptables -A DEF -s 169.254.0.0/16 -j DROP
#iptables -A DEF -s 192.0.0.0/24 -j DROP
#iptables -A DEF -s 192.0.2.0/24 -j DROP
#iptables -A DEF -s 198.18.0.0/15 -j DROP
#iptables -A DEF -s 198.51.100.0/24 -j DROP
#iptables -A DEF -s 203.0.113.0/24 -j DROP
#iptables -A DEF -s 224.0.0.0/4 -j DROP
#iptables -A DEF -s 240.0.0.0/4 -j DROP
#iptables -A DEF -s 255.255.255.255/32 -j DROP
iptables -A DEF -d 127.0.0.0/8 -j DROP
iptables -A DEF -d 224.0.0.0/4 -j DROP
iptables -A DEF -d 255.255.255.255/32 -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,PSH,ACK,URG -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,PSH,URG -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN,SYN,RST,ACK,URG -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags SYN,ACK SYN,ACK -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset
iptables -A DEF -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j DROP
iptables -A DEF -p udp -m length --length 0:28 -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m recent --update --seconds 1 --hitcount 11 --name INSYN --mask 255.255.255.255 --rsource -j DROP
iptables -A DEF -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m recent --set --name INSYN --mask 255.255.255.255 --rsource -j RETURN
iptables -A DEF -j RETURN
#ICMPF CHAIN filtering ICMP
iptables -A ICMPF -s 176.192.230.26/32 -j ACCEPT
iptables -A ICMPF -j DROP
#SIPACL CHAIN filtering SIP
iptables -A SIPACL -s 176.192.230.26/32 -j ACCEPT
iptables -A SIPACL -s $localnet -j ACCEPT
iptables -A SIPACL -m string --string "OPTIONS" --algo bm --to 1500 -j ACCEPT
iptables -A SIPACL -m string --string "INVITE" --algo bm --to 1500 -m hashlimit --hashlimit-upto 4/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_I_limit -j ACCEPT
iptables -A SIPACL -m string --string "REGISTER" --algo bm --to 1500 -m hashlimit --hashlimit-upto 2/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_R_limit -j ACCEPT
iptables -A SIPACL -m hashlimit --hashlimit-upto 10/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_o_limit -j ACCEPT
iptables -A SIPACL -p udp -m udp --dport $sipport -m recent --update --name MYSIP --mask 255.255.255.255 --rsource -j ACCEPT
iptables -A SIPACL -p udp -m udp --dport $sipport -j DROP
iptables -A SIPACL -m geoip ! --source-country RU,UA  -j DROP
iptables -A SIPACL -j RETURN
#SSHC CHAIN filtering SSH
iptables -A SSHC -m state --state NEW -m hashlimit --hashlimit-above 5/min --hashlimit-burst 5 --hashlimit-mode srcip --hashlimit-name SSH -j REJECT --reject-with icmp-port-unreachable
iptables -A SSHC -m state --state NEW -j ACCEPT

#iptables RAW rules
#Creating raw CHAINS
iptables -t raw -P PREROUTING ACCEPT
iptables -t raw -P OUTPUT ACCEPT
iptables -t raw -N BAD
iptables -t raw -N BADSIP
iptables -t raw -N NEWSIP
iptables -t raw -N UDPSIP
#PREROUTING TABL
iptables -t raw -A PREROUTING -s $localnet -j ACCEPT
iptables -t raw -A PREROUTING -s 176.192.230.26/32 -j ACCEPT
iptables -t raw -A PREROUTING -j BAD
iptables -t raw -A PREROUTING -i eth+ -m recent --update --name MYSIP --mask 255.255.255.255 --rsource -j ACCEPT
iptables -t raw -A PREROUTING -i eth+ -p udp -m udp --dport $sipport -m string --string "$hostname" --algo bm --to 1500 --icase -j NEWSIP
iptables -t raw -A PREROUTING -i eth+ -m recent --update --name BADSIP --mask 255.255.255.255 --rsource -j DROP
iptables -t raw -A PREROUTING -i eth+ -p udp -m udp --dport $sipport -j UDPSIP
#BAD CHAIN filtering BAD guys manualy
iptables -t raw -A BAD -s 106.12.175.0/24 -j DROP
iptables -t raw -A BAD -s 103.253.42.0/24 -j DROP
iptables -t raw -A BAD -s 185.53.88.0/24 -j DROP
iptables -t raw -A BAD -s 45.143.220.0/24 -j DROP
iptables -t raw -A BAD -s 156.96.0.0/16 -j DROP
iptables -t raw -A BAD -s 103.145.12.0/24 -j DROP
#BADSIP CHAIN filtering bad guys from UDPSIP Cgaub
iptables -t raw -A BADSIP -m recent --set --name BADSIP --mask 255.255.255.255 --rsource -j DROP

iptables -t raw -A NEWSIP -m recent --set --name MYSIP --mask 255.255.255.255 --rsource -j ACCEPT
iptables -t raw -A UDPSIP -m state --state NEW -m hashlimit --hashlimit-above 10/min --hashlimit-burst 5 --hashlimit-mode srcip --hashlimit-name SIP -j DROP
iptables -t raw -A UDPSIP -m string --string "sundayddr" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sipsak" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sipvicious" --algo bm --to 1500 --icase -j BADSIP
iptables -t raw -A UDPSIP -m string --string "friendly-scanner" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "iWar" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sip-scan" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sipcli" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "eyeBeam" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "friendly-request" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sipvicious" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "smap" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "FPBX" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "Zfree" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "Z 3.14.38765 rv2.8.3" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sipcli/v1.8" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "PBX" --algo bm --to 1500 -j BADSIP
ipsave
end