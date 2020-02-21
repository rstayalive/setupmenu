#!/bin/bash
#FPBX running on 10.13.66X versions firmware update script
end()
{
echo -e "Press any key to continue"
read -s -n 1
}
clear
echo "Upgrade job running"
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
echo FPBX $version
echo Checking for new upgrades...
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
echo FPBX upgraded to $version
echo ----------------------------------------
echo ""
end