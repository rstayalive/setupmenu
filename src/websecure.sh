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
AuthName "fuck closed"
AuthUserFile /home/asterisk/.htpasswd
SetEnvIf Request_URI "^/records/*" allow
Order allow,deny
Require valid-user
Allow from env=allow
Deny from env=!allow
Satisfy any


<Files .htpasswd>
deny from all
</Files>' > /var/www/html/.htaccess 


echo -e "\n$GREВведите пароль на доступ к веб интерфейсу$DEF"
read pass ;
htpasswd -c -b /home/asterisk/.htpasswd sadmin $pass
htpasswd - b /home/asterisk/.htpasswd records records
service httpd restart
echo -e "$GREНастройка завершена!$DEF"
waitend
