#!/bin/bash
#Скрипт настройки пропущенных уведомлений с ivr меню на почту

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

#Переменные callerid и nodest
callerid='${CALLERID(num)}'
nodest='${NODEST}'
workdir='/root/setupmenu/src'

#Запросы
echo -e "\n$GREС какого email будем отправлять письма?$DEF"
read sender ;
echo -e "\n$GREНа какой ящик отправлять?$DEF"
read emailto ;

#Выкачиваем sendEmail.pl и кладем его в /usr/local/bin/
cp $nodest/sendEmail.pl /usr/local/bin/
cd /usr/local/bin/
chmod 777 sendEmail.pl
cd /

#Вносим изменения в файл extensions_override_freepbx.conf
echo -e " 
[ivr-1]
exten => h,1,System(/usr/local/bin/sendEmail.pl -f $sender -t $emailto -u "Пропущенный вызов с номера $callerid" -m "Пропущенный вызов пришел с IVR звонили с номера $callerid" -o message-charset=UTF-8)
same  => n,Hangup()
" >> /etc/asterisk/extensions_override_freepbx.conf
service asterisk restart
echo "Готово"
waitend