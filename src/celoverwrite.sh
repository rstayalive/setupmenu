#! /bin/bash
# Скрипт замены файла cel.conf для работы простых звонков.
# Часто после обновы модулей, переписывается этот файл.
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

#Кастом wait
waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

workdir='/root/menu/src'

#Начало работы
clear
	echo "Провожу замену cel.conf"
	cp /var/www/html/admin/modules/cel/etc/cel.conf /root/cel.conf_orig
	rm -f /var/www/html/admin/modules/cel/etc/cel.conf
	cp $workdir/cel.conf /var/www/html/admin/modules/cel/etc/
	fwconsole chown
	echo "Готово, перезапускаю астериск"
	fwconsole reload
waitend

	
	