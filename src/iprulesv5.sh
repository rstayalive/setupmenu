#!/bin/bash
#Новая версия защиты от 15.04.18
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
#end
end()
{
echo -e "$GREНажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}
#Сохранить правила или нет
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
#Y/N
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
echo -e "\nВведите sip port астериска или диапазон портов, формат 5060:5061 для диапазона, либо 5060 для одного порта"
read sipport ;
echo -e "\nВведите локальную сеть, которую нужно добавить в исключения формат 192.168.0.0/24"
read localnet ;
echo -e "\nВведите Страну или страны из которых можно подключаться к астериску, пример RU,LV,US без пробела"
read country ;
#Обезопасим себя от потери удаленного доступа к серваку, если что-то пойдет не так
service iptables stop
iptables -F
# Правила
iptables -N SIPACL
iptables -A INPUT -p tcp -m multiport --dports 22,80,443,9980 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 5038 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 10150 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 8077,8078 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
iptables -A INPUT -p udp -m state --state NEW -m udp --dport $sipport -j SIPACL
iptables -I SIPACL 1 -s $localnet -j ACCEPT
iptables -A SIPACL -s 176.192.230.26 -j ACCEPT
iptables -A SIPACL -j LOG --log-prefix "SIPACL:"
iptables -A SIPACL -p all -m string --string "tel:" --algo bm --to 65 -j REJECT
iptables -A SIPACL -m string --string "OPTIONS SIP:" --algo bm --to 65 -j ACCEPT
iptables -A SIPACL -m string --string "INVITE SIP:" --algo bm --to 65 -m hashlimit --hashlimit-upto 4/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_i_limit -j ACCEPT
iptables -A SIPACL -m string --string "REGISTER SIP:" --algo bm --to 65 -m hashlimit --hashlimit-upto 2/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_i_limit -j ACCEPT
iptables -A SIPACL -m hashlimit --hashlimit-upto 10/min --hashlimit-burst 1 --hashlimit-mode srcip,dstport --hashlimit-name sip_o_limit -j ACCEPT
iptables -A SIPACL -p all -m string --string "friendly-scanner" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "friendly-request" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sip-scan" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sundayddr" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "iWar" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sipsak" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sipvicious" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sipcli" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sip-scan" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "eyeBeam" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "VaxSIPUserAgent" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sip:nm@nm" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "smap" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "FPBX" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "Zfree" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "Z 3.14.38765 rv2.8.3" --algo bm --to 65 -j REJECT
iptables -A SIPACL -p all -m string --string "sipcli/v1.8" --algo bm --to 65 -j REJECT
iptables -A SIPACL -m geoip ! --src-cc $country -j REJECT
iptables -A SIPACL -j REJECT
iptables -A INPUT -s $localnet -j ACCEPT
iptables -A INPUT -s 176.192.230.26 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags ALL ACK,RST,SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -f -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -m geoip ! --src-cc $country -j DROP
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
#Сохраняем правила и запускаем iptables 
service iptables save
service iptables start
#Вывод правил
clear
iptables -vnL
end