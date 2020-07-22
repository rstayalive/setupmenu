#!/bin/bash
#iptables rule set with geoip rules and raw table only centos7.x
#maybe work on 6.x but don't shure about that
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
#input table
iptables -F
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
iptables -N SIPACL
iptables -N DEF
iptables -I INPUT 1 -p tcp --dport $sipport -m conntrack --ctstate RELATED,ESTABLISHED -m recent ! --rcheck --name MYSIP -j DROP
iptables -I INPUT 2 -m conntrack --ctstate INVALID -j DROP
iptables -I INPUT 3 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -m conntrack --ctstate NEW -j ACCEP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 176.192.230.26 -j ACCEPT
iptables -A INPUT -s $localnet -j ACCEPT
iptables -A INPUT -i eth+ -j DEF
iptables -A INPUT -p tcp -m multiport --dports 80,443,9980 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 8077,8078 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 5038 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 10150 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
iptables -A INPUT -j SIPACL
iptables -A INPUT -j DROP
#output table
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A OUTPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A OUTPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A OUTPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -A OUTPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A OUTPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A OUTPUT -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -A OUTPUT -p tcp --tcp-flags SYN,ACK SYN,ACK -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset
iptables -A OUTPUT -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
iptables -A OUTPUT -f -j DROP
#DEFEND channel
iptables -A DEF -m state --state INVALID -j DROP
iptables -A DEF -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A DEF -s 10.0.0.0/8 -j DROP
iptables -A DEF -s 172.16.0.0/12 -j DROP
iptables -A DEF -s 192.168.0.0/16 -j DROP
iptables -A DEF -s 0.0.0.0/8 -j DROP
iptables -A DEF -s 100.64.0.0/10 -j DROP
iptables -A DEF -s 127.0.0.0/8 -j DROP
iptables -A DEF -s 169.254.0.0/16 -j DROP
iptables -A DEF -s 192.0.0.0/24 -j DROP
iptables -A DEF -s 192.0.2.0/24 -j DROP
iptables -A DEF -s 198.18.0.0/15 -j DROP
iptables -A DEF -s 198.51.100.0/24 -j DROP
iptables -A DEF -s 203.0.113.0/24 -j DROP
iptables -A DEF -s 224.0.0.0/4 -j DROP
iptables -A DEF -s 240.0.0.0/4 -j DROP
iptables -A DEF -s 255.255.255.255 -j DROP
iptables -A DEF -d 0.0.0.0/8 -j DROP
iptables -A DEF -d 127.0.0.0/8 -j DROP
iptables -A DEF -d 224.0.0.0/4 -j DROP
iptables -A DEF -d 255.255.255.255 -j DROP
iptables -A DEF -p tcp --tcp-flags ALL NONE -j DROP
iptables -A DEF -p tcp --tcp-flags ALL ALL -j DROP
iptables -A DEF -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A DEF -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -A DEF -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A DEF -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A DEF -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG FIN -j DROP
iptables -A DEF -p tcp --tcp-flags SYN,ACK SYN,ACK -m conntrack --ctstate NEW -j REJECT --reject-with tcp-reset
iptables -A DEF -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
iptables -A DEF -p udp -m length --length 0:28 -j DROP
iptables -A DEF -p tcp --syn -m recent --update --name INSYN --seconds 1 --hitcount 11 -j DROP
iptables -A DEF -p tcp --syn -m recent --set --name INSYN -j RETURN
iptables -A DEF -j RETURN
#SIP channel
iptables -A SIPACL -s $localnet -j ACCEPT
iptables -A SIPACL -s 212.188.36.179/32 -j ACCEPT
iptables -A SIPACL -s 62.141.108.0/24 -j ACCEPT
iptables -A SIPACL -s 185.45.152.0/24 -j ACCEPT
iptables -A SIPACL -s 185.45.155.0/24 -j ACCEPT
iptables -A SIPACL -s 37.139.38.0/24 -j ACCEPT
iptables -A SIPACL -s 195.122.19.0/27 -j ACCEPT
iptables -A SIPACL -s 103.109.103.64/28 -j ACCEPT
iptables -A SIPACL -m string --string "OPTIONS" --algo bm --to 1500 -j ACCEPT
iptables -A SIPACL -m string --string "INVITE" --algo bm --to 1500 -m hashlimit --hashlimit-upto 4/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_i_limit -j ACCEPT
iptables -A SIPACL -m string --string "REGISTER" --algo bm --to 1500 -m hashlimit --hashlimit-upto 2/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_i_limit -j ACCEPT
iptables -A SIPACL -m hashlimit --hashlimit-upto 10/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_o_limit -j ACCEPT
iptables -A SIPACL -p udp --dport $sipport -m recent --update --name MYSIP -j ACCEPT
iptables -A SIPACL -p udp --dport $sipport -j DROP
iptables -A SIPACL -m geoip ! --src-cc $country -j DROP
iptables -A SIPACL -j RETURN
#RAW table and channels -t raw
iptables -t raw -P PREROUTING ACCEPT
iptables -t raw -N NEWSIP
iptables -t raw -N BADSIP
iptables -t raw -N UDPSIP
iptables -t raw -A PREROUTING -i eth+ -m recent --update --name MYSIP -j ACCEPT
iptables -t raw -A PREROUTING -i eth+ -p udp --dport $sipport -m string --string "$domain" --algo bm --to 1500 --icase -j NEWSIP
iptables -t raw -A PREROUTING -i eth+ -m recent --update --name BADSIP -j DROP
iptables -t raw -A PREROUTING -i eth+ -p udp --dport $sipport -j UDPSIP
iptables -t raw -A UDPSIP -m string --string "sundayddr" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sipsak" --algo bm --to 1500 -j BADSIP
iptables -t raw -A UDPSIP -m string --string "sipvicious" --algo bm --icase --to 1500 -j BADSIP
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
iptables -t raw -A BADSIP -m recent --set --name BADSIP -j DROP
iptables -t raw -A NEWSIP -m recent --set --name MYSIP -j ACCEPT
#we finish here, save and start iptables
ipsave
end