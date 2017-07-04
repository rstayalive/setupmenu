#!/bin/bash
#Скрипт который настраивает автообновление сертификатов простых звонков. beta_01
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
#Ждем нажатия любой кнопки.
end()
{
echo "Нажмите любую клавишу чтобы вернуться в меню"
read -s -n 1
}
#Создадим отдельный скрипт, который не будет зависеть от того есть setupmenu или нет и кладем его в /root
prosto='prostiezvonki_cert_upd.sh'
domain=`hostname`
#Проверяем настроен доменный сертификат или нет (тупо чекаем hostname, т.к при получении сертификата через certificate management нужно задавать hostname согласно сделанной A записи на домене)
#соответственно если hostname localhost.localdomain ничего настроено не было и смысла выполнять скрипт нет.
if [ "$domain" == "localhost.localdomain" ];
then
echo -e "$REDДоменный сертификат не настроен или не изменен hostname, продолжить невозможно! Получите сначала сертификат и измените hostname! выходим...$DEF"
else
#Проверяем наличие файла случай не однократного запуска скрипта.
if [[ -f "/root/$prosto" && -s "/root/$prosto" ]];
then
echo "уже есть такой файл, пропускаю"
else
touch /root/$prosto
chmod +x /root/$prosto
echo '
#!/bin/bash
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
exit 0
' >> /root/$prosto
touch /var/log/asterisk/cert.log
#Добавляем задачу в крон, чтобы она исполнялась
echo '
0 0 1 * * root /root/$prosto >> /var/log/asterisk/cert.log 2>&1
' >> /etc/crontab
/etc/init.d/crond restart
cat /etc/crontab
echo "Все настроено!"
fi
fi
end