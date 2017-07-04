#!/bin/bash
#Скрипт проверки ssl сертификата
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
#wait
wait()
{
echo -e "$GRE Для продолжения нажмите любую клавишу $DEF"
read -s -n 1
}
domain=`hostname`
clear
echo "Проверяю Ваш сертификат"
curl --insecure -v https://$domain:10150 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' >> /tmp/certlog.txt
echo -e "$REDДата истечения сертификата$DEF"
grep 'expire date' /tmp/certlog.txt
rm -rvf /tmp/cert*
echo -e "$GREВсе готово, ключи были обновлены!$DEF"
wait
