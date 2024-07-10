#!/bin/bash
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
#Делаем простым звонкам запрос
domain=`hostname`
startdate=$(curl --insecure -v https://127.0.0.1 2>&1 | grep 'start date' | cut -d':' -f2-)
expiredate=$(curl --insecure -v https://127.0.0.1 2>&1 | grep 'expire date' | cut -d':' -f2-)
#Проверяем настроен доменный сертификат или нет (тупо чекаем hostname, т.к при получении сертификата через certificate management нужно задавать hostname согласно сделанной A записи на домене)
#соответственно если hostname localhost.localdomain ничего настроено не было и смысла выполнять скрипт нет.
if [ "$domain" == "localhost.localdomain" ];
then
echo -e "$REDДоменный сертификат не настроен или не изменен hostname, продолжить невозможно! Получите сначала сертификат и измените hostname! выходим...$DEF"
else
cd /etc/asterisk/
mkdir -p oldkeys
chown asterisk:asterisk /etc/asterisk/oldkeys
mv newsert.pem /etc/asterisk/oldkeys
mv privkey1.pem /etc/asterisk/oldkeys
#mv dh512.pem /etc/asterisk/oldkeys
ln -s /etc/asterisk/keys/$(hostname)/cert.pem /etc/asterisk/newsert.pem
ln -s /etc/asterisk/keys/$(hostname)/private.pem /etc/asterisk/privkey1.pem
chown -R asterisk:asterisk /etc/asterisk
rasterisk -rx"core restart now"
echo -e "Дата начала действия сертификата$startdate
Дата окончания действия сертификата$expiredate"
fi
end