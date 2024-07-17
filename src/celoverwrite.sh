#! /bin/bash
# Скрипт вносит необходимые изменения в cel_general_custom для работы простых звонков
#Кастом wait
end()
{
echo -e "Нажмите любую клавишу чтобы вернуться в меню"
read -s -n 1
}
workdir='/root/setupmenu/src'
echo "[general]
enable=yes
apps=dial,park,mixmonitor
events=ALL

[manager]
enabled=yes" >> /etc/asterisk/cel_general_custom.conf
end