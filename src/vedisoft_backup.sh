#!/bin/bash
mkdir -p /root/backup_vedisoft/

ASTER_MOD_DIR=$(asterisk -rx "core show settings" | grep "Module directory" | awk '{print $NF}')
MODDIR=$(ldconfig -p | awk -F"=>" '{print $2}' | grep '/usr/' | head -1 |sed 's/^[ \t]*//' | cut -d'/' -f1-3)
CONFPATH="/etc/asterisk"
BACKUPDIR="/root/backup_vedisoft/"
FPBXPZ="/var/www/html/admin/modules/prostiezvonki/"

tar -cvf - $FPBXPZ | lz4 > /root/backup_vedisoft/prostiezvonki.tar.lz4
cp $CONFPATH/cel_prostiezvonki.conf $BACKUPDIR/cel_prostiezvonki.conf
echo "cel_prostiezvonki.conf backuped"
cp $MODDIR/libProtocolLib.so $BACKUPDIR/libProtocolLib.so
echo "libProtocolLib.so backuped"
cp $ASTER_MOD_DIR/cel_prostiezvonki.so $BACKUPDIR/cel_prostiezvonki.so
echo "cel_prostiezvonki.so backuped"
echo "all jobs done."