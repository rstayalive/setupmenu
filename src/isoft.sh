#!/bin/bash
#This script install some admin tools to system
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
echo -e "Нажмите любую клавишу чтобы вернуться в меню"
read -s -n 1
}
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
    myinstall smartmontools
    myinstall nmon
	myinstall lz4
	myinstall lz4-devel
echo "Ставлю sngrep"
cd /usr/src
git clone https://github.com/irontec/sngrep
cd sngrep
./bootstrap.sh
sleep 3
./configure --with-openssl --enable-unicode
sleep 3
make
speep 3
make install
echo "alias sngrep='NCURSES_NO_UTF8_ACS=1 sngrep'" >> ~/.bashrc
echo export NCURSES_NO_UTF8_ACS=1 >> /etc/environment
echo "Установлено, можешь теперь жать кнопки"
service smartd start
chkconfig smartd on
end