#!/bin/bash
# Скрипт настройки postfix для отправки уведомлений на почту
# echo "This is the body of the email. Test. Test. Test." | mail -s "Direct email test 01" -r asterisk.maildelivery@gmail.com youremail@here
#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#end
waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

#Y/N
myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]] #запрашиваем значение, пока не будет "y" или "n"
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}

clear
echo "
------------------------------------------------------
Произвожу настройку необходимых файлов
------------------------------------------------------
"
#main.cf и sasl_passwd
	echo -e "$GREИспользовать email (Y)asterisk.maildelivery@gmail.com или (N)свой email?$DEF"
	myread_yn ans
	case "$ans" in
 y|Y)
        replace "inet_protocols=all" "inet_protocols=ipv4" -- /etc/postfix/main.cf
        service postfix restart
        echo "@gmail.com asterisk.maildelivery@gmail.com" >> /etc/postfix/generic
        postmap /etc/postfix/generic
		touch /etc/postfix/sasl_passwd
		echo -e "\nВведите сгенерированный пароль почты!"
		read epasswd ;
		echo "smtp.gmail.com:587 asterisk.maildelivery@gmail.com:$epasswd" > /etc/postfix/sasl_passwd
		chmod 400 /etc/postfix/sasl_passwd
		postmap /etc/postfix/sasl_passwd
        #main.cfg закидываем
        echo "
        smtp_sasl_auth_enable = yes
        smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
        smtp_sasl_security_options = noanonymous
        smtp_sasl_type = cyrus
        smtp_use_tls = yes
        smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
        relayhost = smtp.gmail.com:587
        myhostname = asterisk.maildelivery
        mydomain = com
        myorigin = gmail
        " >> /etc/postfix/main.cf
        postconf -e inet_protocols=ipv4
        service postfix restart
		echo "Настройка завершена. Теперь проверим что все работает."
        echo -e "\nВведите Email куда отправить тестовое письмо"
        read email ;
        echo "Проверка тела письма." | mail -s "Проверка почты" -r asterisk.maildelivery@gmail.com $email 
        echo "отправлено тестовое письмо на $email проверьте почту" ;;
 n|N)
		echo -e "$REDЕсли используете yandex или google аккаунт, обязательно создайте пароль приложения в настройках безопасности и в пароль впишите его, а не пароль от аккаунта иначе работать не будет!!!$DEF"
		echo -e "\nВведите логин. формат blablabla@gmail.com"
		read login ;
		echo -e "\nВведите созданный пароль приложения"
		read passwd ;
        echo -e "\nДля yandex напишите yandex, для google напишите $REDgmail$DEF(пожалуйста не пишите .com .ru etc.)"
        read sender;
        		touch /etc/postfix/sasl_passwd
		echo "smtp.$sender.com:587 $login:$passwd" > /etc/postfix/sasl_passwd
		chmod 400 /etc/postfix/sasl_passwd
		postmap /etc/postfix/sasl_passwd
        if [ "$sender" == "gmail" ]
        then
        echo "@gmail.com $login" >> /etc/postfix/generic
        postmap /etc/postfix/generic
        echo "
        smtp_sasl_auth_enable = yes
        smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
        smtp_sasl_security_options = noanonymous
        smtp_sasl_type = cyrus
        smtp_use_tls = yes
        smtp_tls_CAfile = /etc/pki/tls/certs/ca-bundle.crt
        relayhost = smtp.gmail.com:587
        myhostname = asterisk.maildelivery
        mydomain = com
        myorigin = gmail
        " >> /etc/postfix/main.cf
        postconf -e inet_protocols=ipv4
        service postfix restart
        echo "Настройка завершена. Теперь проверим что все работает."
        echo -e "\nВведите Email куда отправить тестовое письмо"
        read email ;
        echo "Проверка тела письма." | mail -s "Проверка почты" -r $login $email
        echo "отправлено тестовое письмо на $email проверьте почту"
        else
        echo "@yandex.com $login" >> /etc/postfix/generic
        postmap /etc/postfix/generic
        echo "
        relayhost = smtp.yandex.com:587
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
waitend