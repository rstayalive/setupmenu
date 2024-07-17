#!/bin/bash
#cdr codepage fix
#backup db
mysqldump -u root --all-databases | gzip > /root/database.sql.gz
#installing mysql odbc connector
odbc=`rpm -qa | grep mysql-connector-odbc`
rpm -e --nodeps $odbc
yum install mariadb-connector-odbc -y
#check config for [mariadb] configuration
if grep -F -x '[MariaDB]' /etc/odbcinst.ini;
then
echo "already configured"
else
#configuring mariadb odbc connector
echo "[MariaDB]
Description=ODBC for MariaDB
Driver=/usr/lib64/libmaodbc.so
Setup=/usr/lib64/libodbcmyS.so
UsageCount=2" >> /etc/odbcinst.ini
fi
fwconsole restart
clear
echo "all done!"