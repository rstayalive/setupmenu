#!/bin/bash
#Установка файла конфигурации click2call

#Цвета
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

#Рабочая папка
workdir='/root/setupmenu/src'

echo "Начинаем..."
cp $workdir/chcall.php /var/www/html
cd /var/www/html
chown asterisk:asterisk chcall.php
echo -e "\nВведите IP астериска"
read astip ;
replace "asteriskip" "$astip" -- chcall.php
echo "Готово!"
waitend