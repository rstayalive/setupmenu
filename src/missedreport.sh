#!/bin/bash
#Скрипт настройки крона на уведомление о пропущенных звонках на email

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
workdir='/root/setupmenu/src'

#Начало работы
clear
echo "Начинаю настройку"
cp $workdir/missed.php /var/www/html/
cd /var/www/html/
chown asterisk:asterisk /var/www/html/missed.php
echo -e "\nВведите email на который будет приходить отчет"
read toemail ;
	replace "myemail" "$toemail" -- /var/www/html/missed.php

#Создаем пользователя в базе asteriskcdrdb
	mysql -e "CREATE USER 'report'@'localhost' IDENTIFIED BY '2yCg6e8r5ng';"
    mysql -e "GRANT SELECT ON asteriskcdrdb.cdr TO 'report';"
    mysql -e "FLUSH PRIVILEGES;"
	
#Добавляем записи в cron
echo "
59 23 * * * php /var/www/html/missed.php" >> /etc/crontab

#Запрос на сделать тестовый запуск?
echo -e "$GREСделать тестовый запуск? (Y)/(N)$DEF"
	myread_yn ans
	case "$ans" in
		y|Y)
		php /var/www/html/missed.php
		echo "$GREПолучайте письмо на $toemail$DEF"
		sleep 2 ;;
		n|N)
		echo "Все настроено и готово к работе!" ;;
esac
waitend