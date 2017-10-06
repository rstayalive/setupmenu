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
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
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
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -f -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -m geoip ! --src-cc RU -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
iptables -A OUTPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A OUTPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A OUTPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A OUTPUT -f -j DROP
iptables -A OUTPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A OUTPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -P OUTPUT ACCEPT
iptables -P INPUT DROP
echo "Правила успешно добавлены"
save
clear
iptables -L -v -n
waitend