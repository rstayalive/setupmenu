#!/bin/bash
#This script configuring asterisk to sending missed calls to email at 23:59, 17:40, 14:00.
workdir='/root/setupmenu/src'
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
clear
cp $workdir/missed_new.php /var/www/html/
cd /var/www/html/
chown asterisk:asterisk /var/www/html/missed_new.php
echo -e "\nPlease enter email for missed cals"
read toemail ;
replace "myemail" "$toemail" -- /var/www/html/missed_new.php
#Creating user and grant privileges to sql
	mysql -e "CREATE USER 'report'@'localhost' IDENTIFIED BY '2yCg6e8r5ng';"
    mysql -e "GRANT SELECT ON asteriskcdrdb.cdr TO 'report';"
    mysql -e "FLUSH PRIVILEGES;"
#Creating crong jobs
echo "
#missed report every midnight
59 23 * * * /usr/bin/php /var/www/html/missed_new.php
#missed report 14:00
01 14 * * * /usr/bin/php /var/www/html/missed_new.php
#missed report 17:40
40 17 * * * /usr/bin/php /var/www/html/missed_new.php
" >> /etc/crontab
#Asking for running test
echo -e "Make test run? (Y)/(N)"
	myread_yn ans
	case "$ans" in
		y|Y)
		php /var/www/html/missed_new.php
		echo "Email sent to $toemail"
		sleep 2 ;;
		n|N)
		echo "Job done." ;;
esac
end