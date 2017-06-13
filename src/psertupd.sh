#!/bin/bash
#Скрипт обновления доменного сертификата для простых звонков

#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#wait
wait()
{
echo -e "$GREДля продолжения нажмите любую клавишу $DEF"
read -s -n 1
}

echo "Начинаем..."
#выкидываем старые ключи в oldkeys в /etc/asterisk
cd /etc/asterisk/
mkdir -p oldkeys
chown asterisk:asterisk /etc/asterisk/oldkeys
mv newsert.pem /etc/asterisk/oldkeys
mv privkey1.pem /etc/asterisk/oldkeys
md dh512.pem /etc/asterisk/oldkeys
#Спрашиваем домен, закидываем новые ключи в /etc/asterisk
echo -e "\nВведите sip.домен"
read sipdom ;
cd /etc/asterisk/keys/$sipdom/
cp cert.pem /etc/asterisk/newsert.pem
cp private.pem /etc/asterisk/privkey1.pem

chown -R asterisk:asterisk /etc/asterisk/
service asterisk restart

#Проверяем сертификат, выводим дату окончания сертификата
clear
echo "Проверяю Ваш сертификат"
curl --insecure -v https://$sipdom:10150 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' >> /tmp/certlog.txt
echo -e "$REDДата истечения сертификата$DEF"
grep 'expire date' /tmp/certlog.txt
rm -rvf /tmp/cert*
echo -e "$GREВсе готово, ключи были обновлены!$DEF"
wait