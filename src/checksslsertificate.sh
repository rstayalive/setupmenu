#!/bin/bash
#Скрипт проверки ssl сертификата
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
#end
end()
{
echo -e "$GRE Для продолжения нажмите любую клавишу $DEF"
read -s -n 1
}
domain=`hostname`
#Проверяем настроен доменный сертификат или нет (тупо чекаем hostname, т.к при получении сертификата через certificate management нужно задавать hostname согласно сделанной A записи на домене)
#соответственно если hostname localhost.localdomain ничего настроено не было и смысла выполнять скрипт нет.
if [ "$domain" == "localhost.localdomain" ];
then
echo -e "$REDДоменный сертификат не настроен или не изменен hostname, продолжить невозможно! Получите сначала сертификат и измените hostname! выходим...$DEF"
else
clear
echo "Проверяю Ваш сертификат"
curl --insecure -v https://$domain:10150 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' >> /tmp/certlog.txt
echo -e "$REDДата истечения сертификата$DEF"
grep 'expire date' /tmp/certlog.txt
rm -rf /tmp/cert*
mail -s testemail $email < /dev/null
fi
end