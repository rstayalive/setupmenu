#!/bin/bash
#Скрипт настройки дополнительной защиты ssh
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
#end
end()
{
echo -e "$GREНажмите любую клавишу $DEF"
read -s -n 1
}
pkgchk=$(rpm -qa | grep -ow GeoIP | head -1)
system=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
workdir='/root/setupmenu/src'
echo "Подготавливаю все необходимое..."
{
#Проверяем версию системы
if [ "$system" == "6.6" ];
then
#Сносим стандартный epel-release репозиторий в котором нет почему то geoip и ставим репо федоры и из него уже ставим geoip
yum erase epel-release -y
yum erase libGeoIP -y
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
myinstall geoip
else
myinstall geoip
fi
} &> /dev/null
#Проверяем, что пакеты установлены и можно продолжить, если не установлены выходим
if [ "$pkgchk" == "GeoIP" ];
then
echo "Используем пакет $pkgchk"
echo -e "\n
$GREИз каких стран можно подключаться к ssh?$DEF
пример: RU UA
Все заглавными буквами, это обязательно"
read zone;
cp $workdir/ssh_defend.sh /root/
chmod 755 /root/ssh_defend.sh
replace "strana" "$zone" -- /root/ssh_defend.sh
echo 'sshd: ALL' >> /etc/hosts.deny
echo 'sshd: ALL: spawn /root/ssh_defend.sh %a' >> /etc/hosts.allow
else
echo -e "$REDНе устанолен пакет GeoIP!$DEF"
exit 0
fi
end