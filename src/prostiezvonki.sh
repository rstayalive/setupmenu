#!/bin/bash
#Скрипт установки простых звонков для астериска

#Алиасы
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

#Запрос циферного значения 1/2
myread_yn()
{
temp=""
while [[ "$temp" != "1" && "$temp" != "1" && "$temp" != "2" && "$temp" != "2" ]] #запрашиваем значение, пока не будет "1" или "2"
do
echo -n -e "$GREВвведите 1 или 2: $DEF"
read -n 1 temp
echo
done
eval $1=$temp
}

#Запрос циферного значения 13/11
myread_ast()
{
temp=""
while [[ "$temp" != "13" && "$temp" != "13" && "$temp" != "11" && "$temp" != "11" ]] #запрашиваем значение, пока не будет "13" или "11"
do
echo -n -e "$GREВведите 13 или 11: $DEF"
read -n 2 temp
echo
done
eval $1=$temp
}

#Выполнение
clear
echo -e "
● Для какого астера ставим?
│
│ ┌─────────────────────────────────────────────┐
├─┤Для asterisk 13 нажмите 13			│
│ ├─────────────────────────────────────────────┤
├─┤Для asterisk 11 нажмите 11			│
  └─────────────────────────────────────────────┘
"
myread_ast ast
	case "$ast" in
	13) clear
echo -e "
● Выбран 13 asterisk, какая разрядность?
│
│ ┌─────────────────────────────────────────────┐
├─┤Для x64 нажмите 1				│
│ ├─────────────────────────────────────────────┤
├─┤Для x86 нажмите 2				│
  └─────────────────────────────────────────────┘
"
myread_yn version
	case "$version" in
	1)
	echo "Ставим простые звонки версию x64 для 13 астериска"
	cd /
	cd /tmp
	echo "Cкачиваю дистрибутив"
	wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk13_x64.zip
	echo "распаковка"
	unzip prostiezvonki_freePBX_asterisk13_x64.zip
	  echo "Установка"
           cp -R prostiezvonki /var/www/html/admin/modules
		fwconsole chown
		fwconsole moduleadmin install prostiezvonki
		fwconsole reload
		cd /var/www/html/admin/modules/prostiezvonki/module/
        cp libProtocolLib.so /usr/lib64/
		cp libProtocolLib.so /usr/lib/
		cp libProtocolLib.so /var/lib/
		cp cel_prostiezvonki.so /usr/lib64/asterisk/modules/
        cd /var/www/html/admin/
        chown -R asterisk:asterisk modules/
        cd /
		fwconsole chown
		fwconsole ma install prostiezvonki
		fwconsole reload
        echo "Создаю символьную ссылку на записи разговоров в /var/www/html/records"
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        cd /etc/asterisk/
		echo "Создаю сертификат для простых звонков"
		mv dh512.pem dh512.pem_back
        openssl dhparam -out dh512.pem 2048
        echo "Создаю новый сертификат"
		openssl req -new -x509 -days 7300 -newkey rsa:1024 -nodes -keyform PEM -keyout privkey1.pem -outform PEM -out newsert.pem -subj "/C=RU/ST=Russia/L=Moscow/O=vedisoft/OU=prostiezvonki/CN=asterisk"
        echo "Все готово! ОБЯЗАТЕЛЬНО!!!!!! настройте модуль в вебморде" ;;
		2)
		echo "Ставим простые звонки версию x86 для 11 астериска"
        cd /
        cd /tmp
        echo "Cкачиваю дистрибутив"
        wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk13_x86.zip
        echo "распаковка"
        unzip prostiezvonki_freePBX_asterisk13_x86.zip
        echo "Установка"
        cp -R prostiezvonki /var/www/html/admin/modules
		fwconsole chown
		fwconsole moduleadmin install prostiezvonki
		fwconsole reload
		cd /var/www/html/admin/modules/prostiezvonki/module/
        cp libProtocolLib.so /usr/lib/
		cp libProtocolLib.so /var/lib/
		cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
        cd /var/www/html/admin/
        chown -R asterisk:asterisk modules/
        cd /
		fwconsole chown
		fwconsole reload
        echo "Создаю символьную ссылку на записи разговоров в /var/www/html/records"
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        cd /etc/asterisk/
		echo "Создаю сертификат для простых звонков"
		mv dh512.pem dh512.pem_back
        openssl dhparam -out dh512.pem 2048
        echo "Создаю новый сертификат"
		openssl req -new -x509 -days 7300 -newkey rsa:1024 -nodes -keyform PEM -keyout privkey1.pem -outform PEM -out newsert.pem -subj "/C=RU/ST=Russia/L=Moscow/O=vedisoft/OU=prostiezvonki/CN=asterisk"
        echo "Все готово! ОБЯЗАТЕЛЬНО!!!!!! настройте модуль в вебморде" ;;
	esac
;;
	11) 
echo -e "
● Выбран 11 asterisk, какую разрядность будем ставить?
│
│ ┌─────────────────────────────────────────────┐
├─┤Для x64 нажмите 1				│
│ ├─────────────────────────────────────────────┤
├─┤Для x86 нажмите 2				│
  └─────────────────────────────────────────────┘
"
	myread_yn version2
	case "$version2" in
	1)
        echo "Ставим простые звонки версию x64 для 11 астериска"
        cd /
        cd /tmp
        echo "Cкачиваю дистрибутив"
        wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk11_x64.zip
        echo "распаковка"
        unzip prostiezvonki_freePBX_asterisk11_x64.zip
        echo "Установка"
        cp -R prostiezvonki /var/www/html/admin/modules
		amportal chown
		amportal a ma install prostiezvonki
		amportal reload
		cd /var/www/html/admin/modules/prostiezvonki/module/
        cp libProtocolLib.so /usr/lib64/
		cp libProtocolLib.so /usr/lib/
		cp libProtocolLib.so /var/lib/
		cp cel_prostiezvonki.so /usr/lib64/asterisk/modules/
        cd /var/www/html/admin/
        chown -R asterisk:asterisk modules/
        cd /
		amportal chown
		amportal reload
        echo "Создаю символьную ссылку на записи разговоров в /var/www/html/records"
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        cd /etc/asterisk/
		echo "Создаю сертификат для простых звонков"
		mv dh512.pem dh512.pem_back
        openssl dhparam -out dh512.pem 2048
        echo "Создаю новый сертификат"
		openssl req -new -x509 -days 7300 -newkey rsa:1024 -nodes -keyform PEM -keyout privkey1.pem -outform PEM -out newsert.pem -subj "/C=RU/ST=Russia/L=Moscow/O=vedisoft/OU=prostiezvonki/CN=asterisk"
        echo "Все готово! ОБЯЗАТЕЛЬНО!!!!!! настройте модуль в вебморде" ;;
	2)
		echo "Ставим простые звонки x86 для 11 астериска"
		cd /tmp
        echo "Cкачиваю дистрибутив"
		wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk11_x86.zip
        echo "распаковка"
        unzip prostiezvonki_freePBX_asterisk11_x86.zip
        echo "Установка"
        cp -R prostiezvonki /var/www/html/admin/modules
		amportal chown
		amportal a ma install prostiezvonki
		amportal reload
		cd /var/www/html/admin/modules/prostiezvonki/module/
        cp libProtocolLib.so /usr/lib/
		cp libProtocolLib.so /var/lib/
		cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
        cd /var/www/html/admin/
        chown -R asterisk:asterisk modules/
        cd /
		amportal chown
		amportal reload
        echo "Создаю символьную ссылку на записи разговоров в /var/www/html/records"
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        cd /etc/asterisk/
		echo "Создаю сертификат для простых звонков"
		mv dh512.pem dh512.pem_back
        openssl dhparam -out dh512.pem 2048
        echo "Создаю новый сертификат"
		openssl req -new -x509 -days 7300 -newkey rsa:1024 -nodes -keyform PEM -keyout privkey1.pem -outform PEM -out newsert.pem -subj "/C=RU/ST=Russia/L=Moscow/O=vedisoft/OU=prostiezvonki/CN=asterisk"
        echo "Все готово! ОБЯЗАТЕЛЬНО!!!!!! настройте модуль в вебморде" ;;
	esac
;;
esac
waitend