#!/bin/bash
#xtables geoip module for iptables installation script
#colors
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
waitend()
{
echo -e "$GRE Press any key to continue$DEF"
read -s -n 1
}
myinstall()
{
if [ -z `rpm -qa $1` ]; then
	yum -y install $1
else
	echo "package $1 already installed"
fi
}
workdir='/root/setupmenu/src'
arc=`arch`
if [ "$arc" == "x86_64" ];
then arc=64
else arc=86
fi
clear
echo "dependency installation"
    myinstall gcc 
    myinstall gcc-c++ 
    myinstall make 
    myinstall automake 
    myinstall unzip 
    myinstall zip 
    myinstall xz 
    myinstall kernel-devel-$(uname -r)
    myinstall kernel-devel.x86_64
    myinstall iptables-devel
    myinstall epel-release
#step 1
if [ "$arc" == "64" ];
then rpm -i ftp://rpmfind.net/linux/dag/redhat/el6/en/x86_64/dag/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
else rpm -i ftp://rpmfind.net/linux/dag/redhat/el6/en/i386/dag/RPMS/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
fi
echo "new repository installed $arc"	
myinstall perl-Text-CSV_XS
PKG_OK=$(rpm -qa | grep perl-Text-CSV_XS)
echo Checking for somelib: $PKG_OK
if [ "" == "$PKG_OK" ];
then
echo "Package not found. installing package from $workdir"
if [ "$arc" == "64" ]; 
then
rpm -i $workdir/perl-Text-CSV_XS-0.80-1.el6.rf.x86_64.rpm
echo "installed x64 package"
else
rpm -i $workdir/perl-Text-CSV_XS-0.85-1.el6.i686.rpm
echo "installed x86 package"
fi
else
echo "Already installed."
fi
#step 2
system=$(grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release)
if [ "$system" == "6.6" ];
then
echo "Starting centos 6 xtables installation"
cp $workdir/xtables-addons-1.47.1.tar.xz /tmp
cd /tmp
tar xvf xtables-addons-1.47.1.tar.xz
cd xtables-addons-1.47.1 
./configure
echo "Replacing some stirngs from autcounf.h"
cd /lib/modules/$(uname -r)/build/include/linux/
if grep -F -x '/*#define CONFIG_IP6_NF_IPTABLES_MODULE 1*/' /lib/modules/$(uname -r)/build/include/linux/autoconf.h;
then
echo "Already changed."
else
echo "Replace done."
replace "#define CONFIG_IP6_NF_IPTABLES_MODULE 1" "/*#define CONFIG_IP6_NF_IPTABLES_MODULE 1*/" -- autoconf.h
fi
#step 3
cd /tmp/xtables-addons-1.47.1
echo "Compilling from src geoip module."
make && make install
sleep 5
cd geoip/ 
cp $workdir/GeoLite2-Country-CSV_20200218.zip .
mv GeoLite2-Country-CSV_*.zip  GeoLite2-Country-CSV.zip
unzip GeoLite2-Country-CSV.zip
mv mv GeoLite2-Country-CSV*/ geoiplite
cp geoiplite/GeoLite2-Country-Blocks-IPv4.csv /tmp/xtables-addons-1.47.1/geoip/
cp geoiplite/GeoLite2-Country-Locations-en.csv /tmp/xtables-addons-1.47.1/geoip/
./xt_geoip_build GeoLite2-Country-Blocks-IPv4.csv
./xt_geoip_build GeoLite2-Country-Locations-en.csv
mkdir -p /usr/share/xt_geoip/ 
cp -r {BE,LE} /usr/share/xt_geoip/
echo "Compilation done"
echo "Enabling xtables module. All jobs done."
modprobe xt_geoip
else
echo "Ставлю xtables для Centos 7"
cp $workdir/xtables-addons-2.14.tar.xz /tmp
cd /tmp
tar -xJf xtables-addons-2.14.tar.xz
cd xtables-addons-2.14
if grep -F -x '#build_TARPIT=m' /tmp/xtables-addons-2.14/mconfig;
then
echo "все ок"
else
replace "build_TARPIT=m" "#build_TARPIT=m" -- /tmp/xtables-addons-2.14/mconfig
echo "подменили"
fi
ln -s /usr/src/kernels/$(uname -r)/ /lib/modules/$(uname -r)/build
./configure
echo "Запускаю компиляцию модуля"
make && make install
sleep 5
cd geoip/ 
#./xt_geoip_dl 
cp $workdir/GeoLite2-Country-CSV_20200218.zip .
mv GeoLite2-Country-CSV_*.zip  GeoLite2-Country-CSV.zip
unzip GeoLite2-Country-CSV.zip
mv GeoLite2-Country-CSV*/ geoiplite
cp geoiplite/GeoLite2-Country-Blocks-IPv4.csv /tmp/xtables-addons-2.14/geoip/
cp geoiplite/GeoLite2-Country-Locations-en.csv /tmp/xtables-addons-2.14/geoip/
./xt_geoip_build GeoLite2-Country-Blocks-IPv4.csv
./xt_geoip_build GeoLite2-Country-Locations-en.csv
mkdir -p /usr/share/xt_geoip/
cp -r {BE,LE} /usr/share/xt_geoip/
modprobe xt_geoip
echo "Модуль geoip установлен"
fi
echo "Подчищаем за собой"
mkdir -p /root/garbage
rm -rf /tmp/xtables*
echo "Все чисто, можно работать дальше"
waitend