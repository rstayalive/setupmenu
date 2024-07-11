#!/bin/bash
#Скрипт проверки ssl сертификата
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
#end
end()
{
echo -e "$GREДля продолжения нажмите любую клавишу $DEF"
read -s -n 1
}
expire_date=$(curl --insecure -v https://127.0.0.1 2>&1 | grep 'expire date' | cut -d':' -f2-)
start_date=$(curl --insecure -v https://127.0.0.1 2>&1 | grep 'start date' | cut -d':' -f2-)
domain=`hostname`
#Проверяем настроен доменный сертификат или нет (тупо чекаем hostname, т.к при получении сертификата через certificate management нужно задавать hostname согласно сделанной A записи в dns домена)
#соответственно если hostname localhost.localdomain ничего настроено не было и смысла выполнять скрипт нет.
if [ "$domain" == "localhost.localdomain" ];
then
echo -e "$REDДоменный сертификат не настроен или не изменен hostname, продолжить невозможно! Получите сначала сертификат и измените hostname! выходим...$DEF"
else
clear
echo -e "Дата начала действия сертификата$start_date
Дата окончания действия сертификата$expire_date"
fi
end