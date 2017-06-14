#!/bin/bash
#Установка файла конфигурации callback с сайта

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

workdir='/root/setupmenu/src'

echo "Начинаем..."
cp $workdir/call.php /var/www/html
cd /var/www/html
chown asterisk:asterisk chcall.php
echo -e "\nВведите IP астериска"
read astip ;
replace "asteriskip" "$astip" -- call.php
echo -e "\nВведите номер очереди или группы куда отдавать звонок формат XXX"
read numb ;
replace "999" "$numb" -- call.php
echo "Готово!"
waitend