#! /bin/bash
# Скрипт настройки postfix для отправки уведомлений на почту

#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#wait
wait()
{
echo -e "$GRE Для продолжения нажмите любую клавишу $DEF"
read -s -n 1
}

#Кастом wait
waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

#Пустая строка
br()
{
echo ""
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
#Настройки для postfix main.cf
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

#sasl_passwd setup
	echo -e "$GREИспользовать email (Y)asterisk.maildelivery@gmail.com или (N)свой email?$DEF"
	myread_yn ans
	case "$ans" in
		y|Y)
		touch /etc/postfix/sasl_passwd
		echo -e "\nВведите сгенерированный пароль почты!"
		read epasswd ;
		echo "smtp.gmail.com:587 asterisk.maildelivery@gmail.com:$epasswd" > /etc/postfix/sasl_passwd
		chmod 400 /etc/postfix/sasl_passwd
		postmap /etc/postfix/sasl_passwd ;
		echo "Готово!" ;;
		n|N)
		echo -e "$REDВ настройках gmail в безопасности необходимо включить 2х этапную аутентификацию и сделать пароль приложения!$DEF"
		wait
		echo -e "\n Введите логин gmail формат blablabla@gmail.com"
		read login ;
		echo -e "\n Введите созданный пароль приложения"
		read passwd ;
		touch /etc/postfix/sasl_passwd
		echo "smtp.gmail.com:587 $login:$passwd" > /etc/postfix/sasl_passwd
		chmod 400 /etc/postfix/sasl_passwd
		postmap /etc/postfix/sasl_passwd
		echo "Готово!" ;;
esac
		
# Перезапуск и тест работы
service postfix restart
echo -e "\nВведите Email для тествого письма"
read email ;
mail -s testmailsend $email < /dev/null
echo -e "$GREПроверяю лог файл на успешную отправку $DEF"
sleep 7
tail /var/log/maillog | grep status=sent
br
echo -e "$GREЕсли все правильно ввели, письмо должно уже было прийти! $DEF"
waitend
