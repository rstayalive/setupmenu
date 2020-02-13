#!/bin/bash
#checking root privileges
if [ ! `id -u` = 0 ]; then echo -en "\033[0;31mERROR: script should be started under superuser\n\033[0m"; exit 1; fi
#Colors
RED=\\e[91m
GRE=\\e[92m
YEL=\\e[33m
DEF=\\e[0m
#define
ASTER_MOD_DIR=$(asterisk -rx "core show settings" | grep "Module directory" | awk '{print $NF}')
MODDIR=$(ldconfig -p | awk -F"=>" '{print $2}' | grep '/usr/' | head -1 |sed 's/^[ \t]*//' | cut -d'/' -f1-3)
CONFPATH="/etc/asterisk"
BACKUPDIR="/root/backup_vedisoft/"
FPBXPZ="/var/www/html/admin/modules/prostiezvonki/"
#Checking backup folder and do some things
if ! [ -d "/root/backup_vedisoft/" ];
then
function dobackup {
    mkdir -p $BACKUPDIR
    tar -cvf - $FPBXPZ | lz4 > /root/backup_vedisoft/prostiezvonki.tar.lz4
    cp $CONFPATH/cel_prostiezvonki.conf $BACKUPDIR/cel_prostiezvonki.conf
    echo "cel_prostiezvonki.conf backuped"
    cp $MODDIR/libProtocolLib.so $BACKUPDIR/libProtocolLib.so
    echo "libProtocolLib.so backuped"
    cp $ASTER_MOD_DIR/cel_prostiezvonki.so $BACKUPDIR/cel_prostiezvonki.so
    echo "cel_prostiezvonki.so backuped"
} > /dev/null 2>&1
    echo "all jobs done. Backup saved here $BACKUPDIR"
else
    echo "Backup Folder exists. Checking files and backuping missing files."
    if ! [ -a "$BACKUPDIR/cel_prostiezvonki.conf" ];
    then 
    cp $CONFPATH/cel_prostiezvonki.conf $BACKUPDIR/cel_prostiezvonki.conf
    echo "cel_prostiezvonki.conf backuped"
    else
    echo -e "$YEL file cel_prostiezvonki.conf already backuped! Backup skiped.$DEF"
    fi
    if ! [ -a "$BACKUPDIR/libProtocolLib.so" ];
    then
    cp $MODDIR/libProtocolLib.so $BACKUPDIR/libProtocolLib.so
    echo "libProtocolLib.so backuped"
    else
    echo -e "$YEL file libProtocolLib.so already backuped! Backup skiped.$DEF"
    fi
    if ! [ -a "$BACKUPDIR/cel_prostiezvonki.so" ];
    then
    cp $ASTER_MOD_DIR/cel_prostiezvonki.so $BACKUPDIR/cel_prostiezvonki.so
    echo "cel_prostiezvonki.so backuped"
    else
    echo -e "$YEL file cel_prostiezvonki.so already backuped! Backup skiped.$DEF"
    fi
    if ! [ -a "$BACKUPDIR/prostiezvonki.tar.lz4" ];
    then
    tar -cvf - $FPBXPZ | lz4 > /root/backup_vedisoft/prostiezvonki.tar.lz4
    echo "vedisoft freepbx module backuped"
    else
    echo -e "$YEL file prostiezvonki.tar.lz4 already backuped! backup skiped.$DEF"
    fi
fi