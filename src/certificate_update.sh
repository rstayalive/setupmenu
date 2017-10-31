#!/bin/bash
#Скрипт ручного обновления сертификата простых звонков
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
domain=`hostname`
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
mv dh512.pem /etc/asterisk/oldkeys
cd /etc/asterisk/keys/$domain/
cp cert.pem /etc/asterisk/newsert.pem
cp private.pem /etc/asterisk/privkey1.pem
#На всякий случай выставляем права и перезапускаем астериск для того чтобы перезапустился АТС-коннектор простых звонков и подцепились сертификаты новые.
chown -R asterisk:asterisk /etc/asterisk/
/etc/init.d/asterisk restart
curl --insecure -v https://127.0.0.1:10150 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' >> /tmp/certlog.txt
echo -e "$REDДата истечения сертификата$DEF"
grep 'expire date' /tmp/certlog.txt
rm -rvf /tmp/cert*
fi
end