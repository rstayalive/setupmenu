#!/bin/bash
#Vedisoft module removing script
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
echo -e "\nYou relealy want to delete vedisoft module?"
myread_yn ans
case "$ans" in
y|Y) 
echo "Deleting vedisoft module"
{
fwconsole ma uninstall prostiezvonki
fwconsole ma delete prostiezvonki
rm -rvf /var/www/html/admin/modules/prostiezvonki
rm -rvf /usr/lib64/libProtocolLib.so
rm -rvf /usr/lib/libProtocolLib.so
rm -rvf /var/lib/libProtocolLib.so
rm -rvf /usr/lib64/asterisk/modules/cel_prostiezvonki.so
rm -rvf /tmp/prostiezvonki*
unlink /var/www/html/records
} &> /dev/null
echo "Module vedisoft successfuly deleted!" ;;
n|N)
echo "Skipping" ;;
esac
end