#!/bin/bash
#Бета версия скрипта установки простых звонков

#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#Конечный wait
waitend()
{
echo -e "$GREНажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

arc=`arch`
prosto=$(fwconsole ma list | grep -ow prostiezvonki)
astver=$(asterisk -V | grep -woE [0-9]+\.)


#Скрываем вывод скрипта, чтобы глаза отдыхали и запускаем выполнение.
echo "Устанавливаю простые звонки...."
{
#Чистим старую установку на случай если уже пытались ставить простые звонки
if [ "$prosto" == "prostiezvonki" ];
	then
	fwconsole ma uninstall prostiezvonki
	fwconsole ma delete prostiezvonki
	rm -rvf /var/www/html/admin/modules/prostiezvonki
	rm -rvf /usr/lib64/libProtocolLib.so
	rm -rvf /usr/lib/libProtocolLib.so
	rm -rvf /var/lib/libProtocolLib.so
	rm -rvf /usr/lib64/asterisk/modules/cel_prostiezvonki.so
	rm -rvf /tmp/prostiezvonki*
	unlink /var/www/html/records
fi
#Смотрим что за астериск установлен, смотрим разрядность системы и начинаем установку соответствующей версии
if [ "$astver" == "13" ];
then
if [ "$arc" == "x86_64" ];
	then
#Для 13 x64
	cd /
		cd /tmp
		wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk13_x64.zip
		unzip prostiezvonki_freePBX_asterisk13_x64.zip
        cp -R prostiezvonki /var/www/html/admin/modules
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
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
else
#Для 13 x86
		cd /
        cd /tmp
	    wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk13_x86.zip
        unzip prostiezvonki_freePBX_asterisk13_x86.zip
        cp -R prostiezvonki /var/www/html/admin/modules
		cd /var/www/html/admin/modules/prostiezvonki/module/
        cp libProtocolLib.so /usr/lib/
		cp libProtocolLib.so /var/lib/
		cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
        cd /var/www/html/admin/
        chown -R asterisk:asterisk modules/
        cd /
		fwconsole chown
		fwconsole moduleadmin install prostiezvonki
		fwconsole reload
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
fi
	else
#Для 11 x64
if [ "$arc" == "x86_64" ];
	then
		cd /
        cd /tmp
        wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk11_x64.zip
        unzip prostiezvonki_freePBX_asterisk11_x64.zip
        cp -R prostiezvonki /var/www/html/admin/modules
		cd /var/www/html/admin/modules/prostiezvonki/module/
        cp libProtocolLib.so /usr/lib64/
		cp libProtocolLib.so /usr/lib/
		cp libProtocolLib.so /var/lib/
		cp cel_prostiezvonki.so /usr/lib64/asterisk/modules/
        cd /var/www/html/admin/
        chown -R asterisk:asterisk modules/
        cd /
		amportal chown
		amportal a ma install prostiezvonki
		amportal reload
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        cd /etc/asterisk/
#Для 13 x86
	else
		cd /tmp
		wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk11_x86.zip
        unzip prostiezvonki_freePBX_asterisk11_x86.zip
        cp -R prostiezvonki /var/www/html/admin/modules
		cd /var/www/html/admin/modules/prostiezvonki/module/
        cp libProtocolLib.so /usr/lib/
		cp libProtocolLib.so /var/lib/
		cp cel_prostiezvonki.so /usr/lib/asterisk/modules/
        cd /var/www/html/admin/
        chown -R asterisk:asterisk modules/
        cd /
		amportal chown
		amportal a ma install prostiezvonki
		amportal reload
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        cd /etc/asterisk/
fi
fi
} &> /dev/null
echo "Установлена версия для asterisk $astver"
waitend