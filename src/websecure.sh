#! /bin/bash
# Скрипт вешает авторизацию на вебморду через .htaccess

#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#Кастом wait
waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню! $DEF"
read -s -n 1
}

echo "Настройка."
touch /var/www/html/.htaccess
echo '
AuthType Basic
AuthName "restricted area"
AuthUserFile /home/asterisk/.htpasswd
require valid-user' > /var/www/html/.htaccess 


echo -e "\n$GREВведите пароль на доступ к веб интерфейсу$DEF"
read pass ;
htpasswd -c -b /home/asterisk/.htpasswd sadmin $pass
service httpd restart
echo -e "$GREНастройка завершена!$DEF"
waitend
