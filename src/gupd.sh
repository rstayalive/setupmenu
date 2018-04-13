#!/bin/bash
#Обновление баз geoip
if ! [ -d /usr/src/xtables-addons-2.14/ ];
then
echo "Распаковываю дистрибутив xtables и обновляем базу geoip"
cp ~/setupmenu/src/xtables-addons-2.14.tar.xz /usr/src
cd /usr/src
tar xvf /usr/src/xtables-addons-2.14.tar.xz
cd /usr/src/xtables-addons-2.14/geoip/
./xt_geoip_dl
./xt_geoip_build GeoIPCountryWhois.csv
mkdir -p /usr/share/xt_geoip/
cp -r {BE,LE} /usr/share/xt_geoip/
modprobe xt_geoip
echo "Все обновлено"
else
echo "Обновляем базу geoip"
cd /usr/src/xtables-addons-2.14/geoip/
./xt_geoip_dl
./xt_geoip_build GeoIPCountryWhois.csv
mkdir -p /usr/share/xt_geoip/
cp -r {BE,LE} /usr/share/xt_geoip/
modprobe xt_geoip
echo "Все обновлено"
fi
