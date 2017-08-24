#!/bin/bash
#Скрипт который настраивает автообновление сертификатов простых звонков. beta_01
#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
#Ждем нажатия любой кнопки.
end()
{
echo -e "$GREНажмите любую клавишу чтобы вернуться в меню$DEF"
read -s -n 1
}
prosto='certificate_autoupdate_cron.sh'
domain=`hostname`
workdir='/root/setupmenu/src'
#Проверяем настроен доменный сертификат или нет (тупо чекаем hostname, т.к при получении сертификата через certificate management нужно задавать hostname согласно сделанной A записи на домене)
#соответственно если hostname localhost.localdomain ничего настроено не было и смысла выполнять скрипт нет.
if [ "$domain" == "localhost.localdomain" ];
then
echo -e "$REDДоменный сертификат не настроен или не изменен hostname, продолжить невозможно! Получите сначала сертификат и измените hostname! выходим...$DEF"
else
#Проверяем наличие файла случай неоднократного запуска скрипта.
if [[ -f "/root/$prosto" && -s "/root/$prosto" ]];
then
echo "уже есть такой файл, пропускаю"
else
echo -e "\nВведите email на который будет приходить письмо с обновленной датой сертификата"
read mailto ;
replace "myemail" "$mailto" -- /root/certificate_autoupdate_cron.sh
cp $workdir/$prosto /root/
chmod +x /root/$prosto
#Проверяем есть ли уже такая запись в кроне или нет.
if grep -F -x '0 0 1 * * root /root/certificate_autoupdate_cron.sh' /etc/crontab;
then
echo "Уже есть задача в кроне"
#Добавляем задачу в крон, чтобы она исполнялась раз в месяц.
else
echo '0 0 1 * * root /root/certificate_autoupdate_cron.sh' >> /etc/crontab
/etc/init.d/crond restart
cat /etc/crontab
echo "Все настроено!"
fi
fi
fi
end