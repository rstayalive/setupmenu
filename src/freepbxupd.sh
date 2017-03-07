#!/bin/bash
# Обновить версию freepbx
#Алиасы
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

wait()
{
echo -e "$GRE Нажмите любую клавишу $DEF"
read -s -n 1
}

waitend()
{
echo -e "$GRE Нажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}

#Начало работы
	clear
		echo "Начинаем обновление"
		ugdir=/root/upgradescripts
		if [ ! -d $ugdir ]
		then
		 mkdir $ugdir
		fi
		version=`cat /etc/schmooze/pbx-version`
		base=`echo $version | cut -f1 -d'-'`
		build=`echo $version | cut -f2 -d'-'`
		echo ""
		echo ----------------------------------------
		echo Сейчас у FreePBX версия $version
		echo Проверю обновления...
		echo ----------------------------------------
		echo ""
		error=0
		while [ $error = 0 ]
		do
		 build=`expr $build + 1`
		 wget http://upgrades.freepbxdistro.org/stable/$base/upgrade-$base-$build.sh -O $ugdir/upgrade-$base-$build.sh
		 error=$?
		 if [ $error = 0 ]
		 then
		  chmod +x $ugdir/upgrade-$base-$build.sh
		  $ugdir/upgrade-$base-$build.sh
		 fi
		done
		clear
		echo ""
		echo ----------------------------------------
		echo Обновлено. $version
		echo ----------------------------------------
		echo ""
waitend