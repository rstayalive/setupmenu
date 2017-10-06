#!/bin/bash
#Скрипт установки расширеных правил безопасности

#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#wait
wait()
{
echo -e "$GRE Нажмите любую клавишу $DEF"
read -s -n 1
}

#Конечный wait
waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

#Сохранить или нет
save()
{
echo "Применить изменения iptables?"
myread_yn ans
case "$ans" in
 y|Y)
 service iptables save
echo -e "$GREПравила успешно добавлены в iptables и применены!$DEF" ;;
 n|N)
 echo -e "$REDИзменения сделаны, но не применены!$DEF" ;;
 esac
}

#Lite or hardcore (для iptables)
myread_lh()
{
temp=""
while [[ "$temp" != "l" && "$temp" != "L" && "$temp" != "h" && "$temp" != "H" ]] 
do
echo -n "L/H: "
read -n 1 temp
echo
done
eval $1=$temp
}

#Y/N
myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]] #запрашиваем значение, пока не будет "y" или "n"
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}

#Начало Работы
echo -e "$GREВыберите режим! (L)Lite(бан всех стран по порту 5060) или (H)HardCore (бан всех стран по всем портам и протоколам, кроме US из-за обновлений)$DEF"
myread_lh lhans
case "$lhans" in
l|L)
iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p TCP -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p UDP -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p ICMP -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j LOG --log-prefix "FIN: "
iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j LOG --log-prefix "PSH: "
iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j LOG --log-prefix "URG: "
iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j LOG --log-prefix "XMAS scan: "
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "NULL scan: "
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j LOG --log-prefix "pscan: "
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j LOG --log-prefix "pscan 2: "
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j LOG --log-prefix "pscan 2: "
iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL SYN,FIN -j LOG --log-prefix "SYNFIN-SCAN: "
iptables -A INPUT -p tcp --tcp-flags ALL SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,FIN -j LOG --log-prefix "NMAP-XMAS-SCAN: "
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j LOG --log-prefix "FIN-SCAN: "
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,SYN,FIN -j LOG --log-prefix "NMAP-ID: "
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j LOG --log-prefix "SYN-RST: "
iptables -I INPUT -p udp --dport 5060 -m string --string "friendly-scanner" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sip-scan" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sundayddr" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "iWar" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipsak" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipvicious" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipcli" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "eyeBeam" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "VaxSIPUserAgent" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sip:nm@nm" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sip:carol@chicago.com" --algo bm -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc CN -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc TW -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc KR -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc KH -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc HK -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc VN -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc JP -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc AE -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc IR -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc CY -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc IQ -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc CL -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc PS -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc OM -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc NG -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc SA -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc VE -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc KE -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc BS -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc MY -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc SG -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc PK -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc MV -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc PG -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc MN -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc TH -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc GE -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc KW -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc AP -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc KP -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc NP -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc ZA -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc AO -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc UG -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc KE -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc CG -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc MZ -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc ZW -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc GH -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc AF -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc TO -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc LY -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc AU -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc CA -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc ID -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc MD -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc IN -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc UA -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc BR -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc NL -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc PL -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc FR -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc GB -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc DE -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc US -j DROP 
echo "Готово! lite правила добавлены!" ;;
h|H)
iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -p icmp -m icmp -m limit --limit 1/second -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p TCP -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p UDP -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p ICMP -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j LOG --log-prefix "FIN: "
iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j LOG --log-prefix "PSH: "
iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j LOG --log-prefix "URG: "
iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j LOG --log-prefix "XMAS scan: "
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j LOG --log-prefix "NULL scan: "
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j LOG --log-prefix "pscan: "
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j LOG --log-prefix "pscan 2: "
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j LOG --log-prefix "pscan 2: "
iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL SYN,FIN -j LOG --log-prefix "SYNFIN-SCAN: "
iptables -A INPUT -p tcp --tcp-flags ALL SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,FIN -j LOG --log-prefix "NMAP-XMAS-SCAN: "
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j LOG --log-prefix "FIN-SCAN: "
iptables -A INPUT -p tcp --tcp-flags ALL FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,SYN,FIN -j LOG --log-prefix "NMAP-ID: "
iptables -A INPUT -p tcp --tcp-flags ALL URG,PSH,SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j LOG --log-prefix "SYN-RST: "
iptables -I INPUT -p udp --dport 5060 -m string --string "friendly-scanner" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sip-scan" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sundayddr" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "iWar" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipsak" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipvicious" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sipcli" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "eyeBeam" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "VaxSIPUserAgent" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sip:nm@nm" --algo bm -j DROP
iptables -I INPUT -p udp --dport 5060 -m string --string "sip:carol@chicago.com" --algo bm -j DROP
iptables -A INPUT -m geoip --src-cc CN -j DROP
iptables -A INPUT -m geoip --src-cc TW -j DROP
iptables -A INPUT -m geoip --src-cc KR -j DROP
iptables -A INPUT -m geoip --src-cc KH -j DROP
iptables -A INPUT -m geoip --src-cc HK -j DROP
iptables -A INPUT -m geoip --src-cc VN -j DROP
iptables -A INPUT -m geoip --src-cc JP -j DROP
iptables -A INPUT -m geoip --src-cc AE -j DROP
iptables -A INPUT -m geoip --src-cc IR -j DROP
iptables -A INPUT -m geoip --src-cc CY -j DROP
iptables -A INPUT -m geoip --src-cc IQ -j DROP
iptables -A INPUT -m geoip --src-cc CL -j DROP
iptables -A INPUT -m geoip --src-cc PS -j DROP
iptables -A INPUT -m geoip --src-cc OM -j DROP
iptables -A INPUT -m geoip --src-cc NG -j DROP
iptables -A INPUT -m geoip --src-cc SA -j DROP
iptables -A INPUT -m geoip --src-cc VE -j DROP
iptables -A INPUT -m geoip --src-cc KE -j DROP
iptables -A INPUT -m geoip --src-cc BS -j DROP
iptables -A INPUT -m geoip --src-cc MY -j DROP
iptables -A INPUT -m geoip --src-cc SG -j DROP
iptables -A INPUT -m geoip --src-cc PK -j DROP
iptables -A INPUT -m geoip --src-cc MV -j DROP
iptables -A INPUT -m geoip --src-cc PG -j DROP
iptables -A INPUT -m geoip --src-cc MN -j DROP
iptables -A INPUT -m geoip --src-cc TH -j DROP
iptables -A INPUT -m geoip --src-cc GE -j DROP
iptables -A INPUT -m geoip --src-cc KW -j DROP
iptables -A INPUT -m geoip --src-cc AP -j DROP
iptables -A INPUT -m geoip --src-cc KP -j DROP
iptables -A INPUT -m geoip --src-cc NP -j DROP
iptables -A INPUT -m geoip --src-cc ZA -j DROP
iptables -A INPUT -m geoip --src-cc AO -j DROP
iptables -A INPUT -m geoip --src-cc UG -j DROP
iptables -A INPUT -m geoip --src-cc KE -j DROP
iptables -A INPUT -m geoip --src-cc CG -j DROP
iptables -A INPUT -m geoip --src-cc MZ -j DROP
iptables -A INPUT -m geoip --src-cc ZW -j DROP
iptables -A INPUT -m geoip --src-cc GH -j DROP
iptables -A INPUT -m geoip --src-cc AF -j DROP
iptables -A INPUT -m geoip --src-cc TO -j DROP
iptables -A INPUT -m geoip --src-cc LY -j DROP
iptables -A INPUT -m geoip --src-cc AU -j DROP
iptables -A INPUT -m geoip --src-cc CA -j DROP
iptables -A INPUT -m geoip --src-cc ID -j DROP
iptables -A INPUT -m geoip --src-cc MD -j DROP
iptables -A INPUT -m geoip --src-cc IN -j DROP
iptables -A INPUT -m geoip --src-cc UA -j DROP
iptables -A INPUT -m geoip --src-cc BR -j DROP
iptables -A INPUT -m geoip --src-cc NL -j DROP
iptables -A INPUT -m geoip --src-cc PL -j DROP
iptables -A INPUT -m geoip --src-cc FR -j DROP
iptables -A INPUT -m geoip --src-cc GB -j DROP
iptables -A INPUT -m geoip --src-cc DE -j DROP
iptables -A INPUT -p udp --dport 5060 -m geoip --src-cc US -j DROP
echo "Hardcore правила добавлены!" ;;
esac
save
clear
iptables -L -v -n
waitend