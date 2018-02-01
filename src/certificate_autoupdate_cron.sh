#!/bin/bash
#Скрипт авто продления сертификата простых звонков
email='myemail'
startdate=$(curl --insecure -v https://127.0.0.1:10150 2>&1 | grep 'start date')
expiredate=$(curl --insecure -v https://127.0.0.1:10150 2>&1 | grep 'expire date')
{
chown -R asterisk:asterisk /etc/asterisk/
fwconsole certificate updateall
/etc/init.d/asterisk restart
} &> /dev/null

echo -e "Дата начала действия сертификата$startdate
Дата окончания действия сертификата$expiredate" |mail -s "Обновлен сертификат на $(hostname)" -r asterisk $email
exit 0