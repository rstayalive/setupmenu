#!/bin/bash
#public postfix configuration script. support google mail, yandex mail
#made by rstayalive from telephonization.ru

RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

echo -e "$REDДля использования учеток yandex или google, обязательно создайте пароль приложения в настройках безопасности и в пароль впишите его, а не пароль от аккаунта иначе работать не будет!!!$DEF"
echo -e "\nДля настройки yandex mail напишите $GREyandex$DEF.Для настройки google mail напишите $GREgmail$DEF($REDПожалуйста не пишите .com .ru etc.$DEF)"
read sender;
echo -e "\nВведите логин. формат blablabla@gmail.com"
read login ;
echo -e "\nВведите созданный пароль приложения"
read passwd ;
touch /etc/postfix/sasl_passwd
echo "[smtp.$sender.com]:587 $login:$passwd" > /etc/postfix/sasl_passwd
chmod 400 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
if [ "$sender" == "gmail" ]
then
echo "
relayhost = [smtp.gmail.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt
" >> /etc/postfix/main.cf
postconf -e inet_protocols=ipv4
service postfix restart
echo "Настройка завершена. Теперь проверим что все работает."
echo -e "\nВведите Email куда отправить тестовое письмо"
read email ;
echo "Проверка тела письма." | mail -s "Проверка почты" -r $login $email
echo "отправлено тестовое письмо на $email проверьте почту"
else
echo "
relayhost = [smtp.yandex.com]:587
smtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt
" >> /etc/postfix/main.cf
postconf -e inet_protocols=ipv4
service postfix restart
echo "Настройка завершена. Теперь проверим что все работает."
echo -e "\nВведите Email куда отправить тестовое письмо"
read email ;
echo "Проверка тела письма." | mail -s "Проверка почты" -r $login $email
echo "отправлено тестовое письмо на $email проверьте почту"
fi
echo "Готово! почта настроена для $login" ;;
esac