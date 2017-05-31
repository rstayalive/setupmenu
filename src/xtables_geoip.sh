#!/bin/bash
#Скрипт сборки geoip модуля для iptables
#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

wait()
{
echo -e "$GRE Нажмите любую клавишу $DEF"
read -s -n 1
}

waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

br()
{
echo ""
}

myinstall()
{
if [ -z `rpm -qa $1` ]; then
	yum -y install $1
else
	echo "Пакет $1 уже установлен"
	br
fi
}
workdir='/root/setupmenu/src'

#Устанавливаем geoip
clear
	echo "Начинаем установку"
		br
			echo "Ставим зависимости"
				myinstall gcc 
				myinstall gcc-c++ 
				myinstall make 
				myinstall automake 
				myinstall unzip 
				myinstall zip 
				myinstall xz 
				myinstall kernel-devel-$(uname -r) 
				myinstall iptables-devel
				myinstall epel-release
				rpm -i ftp://rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
				rpm -i $workdir/perl-Text-CSV_XS-0.80-1.el6.rf.x86_64.rpm
		
		echo "ставим geoip"
	br
		cp $workdir/xtables-addons-1.47.1.tar.xz /tmp
		cd /tmp
		tar xvf xtables-addons-1.47.1.tar.xz
		cd xtables-addons-1.47.1 
		./configure
		cd /lib/modules/$(uname -r)/build/include/linux/
		replace "#define CONFIG_IP6_NF_IPTABLES_MODULE 1" "/*#define CONFIG_IP6_NF_IPTABLES_MODULE 1*/" -- autoconf.h
		cd /tmp/xtables-addons-1.47.1
	br
		echo "Запускаю компиляцию модуля"
		make && make install
	br
		sleep 5
		cd geoip/ 
		./xt_geoip_dl 
		./xt_geoip_build GeoIPCountryWhois.csv 
		mkdir -p /usr/share/xt_geoip/ 
		cp -r {BE,LE} /usr/share/xt_geoip/
		modprobe xt_geoip
	br
		echo "Модуль geoip установлен"
	br
	 echo "Подчищаем за собой"
	 mkdir -p /root/garbage
	 rm -rf /tmp/xtables*
	 mv /etc/yum.repos.d/epel.repo /root/garbage/
	 mv /etc/yum.repos.d/epel-testing.repo /root/garbage/
	 mv /etc/yum.repos.d/mirrors-rpmforge /root/garbage/
	 mv /etc/yum.repos.d/mirrors-rpmforge-extras /root/garbage/
	 mv /etc/yum.repos.d/mirrors-rpmforge-testing /root/garbage/
	 mv /etc/yum.repos.d/rpmforge.repo /root/garbage/
	 echo "Все чисто, можно работать дальше"
waitend