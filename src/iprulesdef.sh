#!/bin/bash
#Скрипт установки "стандартных" правил для FreePBX
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
#Создаем 2 новых chain, один для обработки портов в $sipport другой для обработки входящего трафика в SIPACL по юзерагентам, которые будут #попадать в chain SIPJUNK и сражу дропаться. На всякий случай для тех кто не шарит и будет читать это говно.
#В SIPACL мы дропаем всех кто попадает по юзерагентам как и писал ранее, потом дропаем все тех кто не из Росиии, остальным разрешаем.
#Дальше открываем стандартные для работы http/s/ssh/sip/rtp порты, неограничиваем $localnet, закрываем доступ всех кто не из России.
iptables -N SIPACL
iptables -N SIPJUNK
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport $sipport -j SIPACL
iptables -A SIPACL -s $localnet -j ACCEPT
iptables -A SIPACL -s 213.176.233.0/24 -j ACCEPT
iptables -A SIPACL -s 176.192.230.26 -j ACCEPT
iptables -A SIPACL -j LOG --log-prefix "SIPACL: "
iptables -A SIPACL -p all -m string --string "friendly-scanner" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "friendly-request" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sip-scan" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sundayddr" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "iWar" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sipsak" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sipvicious" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sipcli" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sip-scan" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "eyeBeam" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "VaxSIPUserAgent" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sip:nm@nm" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "smap" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "FPBX" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "Zfree" --algo bm --to 65535 -j SIPJUNK
iptables -A SIPACL -p all -m string --string "Z 3.14.38765 rv2.8.3" --algo bm -j SIPJUNK
iptables -A SIPACL -p all -m string --string "sipcli/v1.8" --algo bm -j SIPJUNK
iptables -A SIPACL -m geoip ! --src-cc RU -j DROP
iptables -A SIPACL -j ACCEPT
iptables -A SIPJUNK -j LOG --log-prefix "SIPJUNK: " --log-level 6 
iptables -A SIPJUNK -j DROP
iptables -A INPUT -p udp -m udp --dport 10000:20000 -j ACCEPT
iptables -A INPUT -s 176.192.230.26 -j ACCEPT
iptables -A INPUT -s 213.176.233.0/24 -j ACCEPT
iptables -A INPUT -s $localnet -j ACCEPT

echo -e "$GREЕсть внешний IP? Y/N$DEF"
myread_yn externip
case "$externip" in
y|Y)
echo -e "\nВведите свой внешний IP формат 8.8.8.8"
read externip ;
iptables -A INPUT -s $externip -j ACCEPT
echo "Готово" ;;
n|N)
echo "Продолжаем" ;;
esac
echo -e "$GREОткрыть порты для простых звонков? Y/N$DEF"
myread_yn ans
case "$ans" in
y|Y)
iptables -A INPUT -p tcp -m tcp --dport 10150:10151 -j ACCEPT
echo "Готово!" ;;
n|N)
echo "Ок, пропускаем" ;;
esac
save
clear
iptables -L -v -n
echo -e "$GREПравила добавлены успешно!$DEF"
end