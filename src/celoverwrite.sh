#! /bin/bash
# Скрипт вносит необходимые изменения в cel_general_custom для работы простых звонков



#Кастом wait
end()
{
echo -e "Нажмите любую клавишу чтобы вернуться в меню"
read -s -n 1
}

workdir='/root/setupmenu/src'

#Начало работы
clear
#	echo "Провожу замену cel.conf"
#	cp /var/www/html/admin/modules/cel/etc/cel.conf /root/cel.conf_orig
#	rm -f /var/www/html/admin/modules/cel/etc/cel.conf
#	cp $workdir/cel.conf /var/www/html/admin/modules/cel/etc/
#	fwconsole chown
#	echo "Готово, перезапускаю астериск"
#	fwconsole reload

echo "[general]
enable=yes
apps=dial,park,mixmonitor
events=ALL

[manager]
enabled=yes" >> /etc/asterisk/cel_general_custom.conf

end