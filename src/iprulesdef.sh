#!/bin/bash
#Скрипт установки стандартных правил для FreePBX

#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#Проверка, установлен пакет или нет
myinstall()
{
if [ -z `rpm -qa $1` ]; then
	yum -y install $1
else
	echo "Пакет $1 уже установлен"
fi
}

#wait
wait()
{
echo -e "$GRE Нажмите любую клавишу $DEF"
read -s -n 1
}

#Конечный wait
waitend()
{
echo -e "$GREНажмите любую клавишу чтобы вернуться в меню $DEF"
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
echo -e "\nВведите sip port астериска или диапазон портов, формат 5060:5061 для диапазона, либо 5060 для одного порта"
read sipport ;
echo -e "\nВведите локальную сеть, которую нужно добавить в исключения формат 192.168.0.0/24"
read localnet ;
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport $sipport -j ACCEPT
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
waitend