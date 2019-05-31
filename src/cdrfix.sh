#!/bin/bash
#cdr codepage fix

odbc=`rpm -qa | grep mysql-connector-odbc`
rpm -e --nodeps $odbc
yum install mariadb-connector-odbc -y

if grep -F -x '[MariaDB]' /etc/odbcinst.ini;
then
echo "уже настроено"
else
echo "[MariaDB]
Description=ODBC for MariaDB
Driver=/usr/lib64/libmaodbc.so
Setup=/usr/lib64/libodbcmyS.so
UsageCount=2" >> /etc/odbcinst.ini
fi
fwconsole restart
clear
echo "Готово!"