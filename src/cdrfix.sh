#!/bin/bash
#cdr codepage fix
# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi
#backup db
backup_file="/root/freepbx_$(date +'%Y%m%d_%H%M%S').sql.gz"
mysqldump --extended-insert --all-databases --add-drop-database --disable-keys --flush-privileges --quick --routines --triggers | gzip > "$backup_file"
#installing mysql odbc connector
#odbc=`rpm -qa | grep mysql-connector-odbc`
#rpm -e --nodeps $odbc
odbc_installed=$(rpm -qa | grep -q mysql-connector-odbc && echo "yes" || echo "no")

if [ "$odbc_installed" = "yes" ]; then
    rpm -e --nodeps $(rpm -qa | grep mysql-connector-odbc)
fi
yum install mariadb-connector-odbc -y
# Configure MariaDB ODBC connector
echo "Configuring MariaDB ODBC connector..."
if grep -q '^\[MariaDB\]' /etc/odbcinst.ini; then
    echo "MariaDB ODBC connector already configured."
else
    echo "[MariaDB]
Description=ODBC for MariaDB
Driver=/usr/lib64/libmaodbc.so
Setup=/usr/lib64/libodbcmyS.so
UsageCount=2" >> /etc/odbcinst.ini
#check config for [mariadb] configuration
#if grep -F -x '[MariaDB]' /etc/odbcinst.ini;
#then
#echo "already configured"
#else
#configuring mariadb odbc connector
#echo "[MariaDB]
#Description=ODBC for MariaDB
#Driver=/usr/lib64/libmaodbc.so
#Setup=/usr/lib64/libodbcmyS.so
#UsageCount=2" >> /etc/odbcinst.ini
#fi
# Restart FreePBX services
fwconsole restart
clear
echo "all done!"