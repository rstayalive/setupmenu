#! /bin/bash
#This script configuring httpd to secure asterisk web interface .htaccess
end()
{
echo -e "Press any key to continue"
read -s -n 1
}
myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]]
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}
if [ -s "/home/asterisk/.htpasswd" ];
then
echo -e "\nAlready configured, do you want reconfigure?"
myread_yn ans
case "$ans" in
y|Y) 
rm -rf /home/asterisk/.htpasswd
rm -rf /var/www/html/.htaccess
echo "Job started"
touch /var/www/html/.htaccess
echo '
AuthType Basic
AuthName "Closed"
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
echo -e "\nEnter password to secure"
read pass ;
htpasswd -c -b /home/asterisk/.htpasswd sadmin $pass
htpasswd -b /home/asterisk/.htpasswd records records
service httpd restart
echo -e "Job done, admin login: sadmin."
echo -e "\nLogin for records: records and Passwd: records" ;;
n|N)
echo -e "Skipping" ;;
esac
else
echo "Job started"
touch /var/www/html/.htaccess
echo '
AuthType Basic
AuthName "Closed"
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
echo -e "\nEnter password to secure"
read pass ;
htpasswd -c -b /home/asterisk/.htpasswd sadmin $pass
htpasswd -b /home/asterisk/.htpasswd records records
service httpd restart
echo -e "Job done, admin login: sadmin."
echo -e "\nLogin for records: records and Passwd: records"
fi
end