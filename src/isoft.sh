#!/bin/bash
#Скрипт установки софта, все из-за лени

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

#end
waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

#Начало работы
clear
echo "Начинаем установку софта, можешь опустить свои ленивые руки"
	myinstall mc
	myinstall mtr
	myinstall iotop
	myinstall lm_sensors.x86_64
	myinstall nmap
	myinstall ncurses-devel 
	myinstall make
	myinstall libpcap-devel
	myinstall pcre-devel
	myinstall openssl-devel
	myinstall git
	myinstall gcc
	myinstall autoconf
	myinstall automake
	myinstall iptraf
    myinstall ccze
echo "Ставлю sngrep"
cd /usr/src
git clone https://github.com/irontec/sngrep
cd sngrep
./bootstrap.sh
sleep 3
./configure
sleep 3
make
speep 3
make install
echo "alias sngrep='NCURSES_NO_UTF8_ACS=1 sngrep'" >> ~/.bashrc
echo export NCURSES_NO_UTF8_ACS=1 >> /etc/environment
echo "Установлено, можешь теперь жать кнопки"
waitend