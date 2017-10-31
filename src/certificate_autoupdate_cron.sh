#!/bin/bash
#Скрипт авто продления сертификата простых звонков
domain=`hostname`
email='myemail'
{
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
} &> /dev/null
#Проверяем сертификат и кладем в /tmp/certlog.txt который отправляем на почту
curl --insecure -v https://127.0.0.1:10150 2>&1 | awk 'BEGIN { cert=0 } /^\* SSL connection/ { cert=1 } /^\*/ { if (cert) print }' >> /tmp/certlog.txt
mail -s "Обновлен сертификат на $domain" -a /tmp/certlog.txt -r asterisk $email < /dev/null
rm -rf /tmp/certlog.txt
exit 0