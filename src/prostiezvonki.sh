#!/bin/bash
#Скрипт установки простыхзвонков

end()
{
echo -e "Нажмите любую клавишу чтобы вернуться в меню"
read -s -n 1
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

arc=`arch`
if [ "$arc" == "x86_64" ];
then arc=64 #В теории возможно обозначение "IA-64" и "AMD64", но я не встречал
else arc=86 #Чтобы не перебирать все возможные IA-32, x86, i686, i586 и т.д.
fi
prosto=$(fwconsole ma list | grep -ow prostiezvonki)
astver=$(asterisk -V | grep -woE [0-9]+\.)

#Сделано на случай, если случайно нажал в скрипте 1 и можно было отменить.
echo -e "$GREНачать установку простых звонков? Y/N$DEF"
myread_yn setupyn
case "$setupyn" in
y|Y)
#Скрываем вывод скрипта, чтобы глаза отдыхали и запускаем выполнение.
echo "Устанавливаю простые звонки.... Процесс установки займет ~5минут."
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
if [ "$arc" == "64" ];
	then
#Для 13 x64
	cd /
		cd /tmp
		wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk13_x64.zip
		unzip prostiezvonki_freePBX_asterisk13_x64.zip
        cp -R /tmp/prostiezvonki /var/www/html/admin/modules/
		cp /var/www/html/admin/modules/prostiezvonki/module/libProtocolLib.so /usr/lib64/
		cp /var/www/html/admin/modules/prostiezvonki/module/libProtocolLib.so /usr/lib/
		cp /var/www/html/admin/modules/prostiezvonki/module/cel_prostiezvonki.so /usr/lib64/asterisk/modules/
        cp /var/www/html/admin/modules/prostiezvonki/module/cel_prostiezvonki.so /usr/lib/asterisk/modules/
        chown -R asterisk:asterisk /var/www/html/admin/modules/
        chown -R asterisk:asterisk /etc/asterisk
		fwconsole chown
		fwconsole ma install prostiezvonki
		fwconsole reload
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        service asterisk restart
    else
#Для 13 x86
        cd /tmp
	    wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk13_x86.zip
        unzip prostiezvonki_freePBX_asterisk13_x86.zip
        cp -R /tmp/prostiezvonki /var/www/html/admin/modules/
		cp /var/www/html/admin/modules/prostiezvonki/module/libProtocolLib.so /usr/lib/
		cp /var/www/html/admin/modules/prostiezvonki/module/libProtocolLib.so /var/lib/
		cp /var/www/html/admin/modules/prostiezvonki/module/cel_prostiezvonki.so /usr/lib/asterisk/modules/
        chown -R asterisk:asterisk /var/www/html/admin/modules/
        chown -R asterisk:asterisk /etc/asterisk
		fwconsole chown
		fwconsole moduleadmin install prostiezvonki
		fwconsole reload
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        service asterisk restart
fi
	else
#Для 11 x64
if [ "$arc" == "64" ];
	then
		cd /
        cd /tmp
        wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk11_x64.zip
        unzip prostiezvonki_freePBX_asterisk11_x64.zip
        cp -R /tmp/prostiezvonki /var/www/html/admin/modules/
        cp /var/www/html/admin/modules/prostiezvonki/module/libProtocolLib.so /usr/lib64/
		cp /var/www/html/admin/modules/prostiezvonki/module/libProtocolLib.so /usr/lib/
		cp /var/www/html/admin/modules/prostiezvonki/module/cel_prostiezvonki.so /usr/lib64/asterisk/modules/
        chown -R asterisk:asterisk /var/www/html/admin/modules/
        chown -R asterisk:asterisk /etc/asterisk
        cd /
		amportal chown
		amportal a ma install prostiezvonki
		amportal reload
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        service asterisk restart
#Для 11 x86
	else
		cd /tmp
		wget http://prostiezvonki.ru/installs/prostiezvonki_freePBX_asterisk11_x86.zip
        unzip prostiezvonki_freePBX_asterisk11_x86.zip
        cp -R /tmp/prostiezvonki /var/www/html/admin/modules/
        cp /var/www/html/admin/modules/prostiezvonki/module/libProtocolLib.so /usr/lib/
		cp /var/www/html/admin/modules/prostiezvonki/module/cel_prostiezvonki.so /usr/lib/asterisk/modules/
        chown -R asterisk:asterisk /var/www/html/admin/modules/
        chown -R asterisk:asterisk /etc/asterisk
		amportal chown
		amportal a ma install prostiezvonki
		amportal reload
        ln -s /var/spool/asterisk/monitor/ /var/www/html/records
        service asterisk restart
fi
fi
} &> /dev/null
echo "Установлена версия для asterisk $astver x$arc" ;;
n|N)
echo "Отмена установки" ;;
esac
end