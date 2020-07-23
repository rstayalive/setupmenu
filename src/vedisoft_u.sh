#!/bin/bash
#vedisoft update module
end()
{
echo -e "Please press any key"
read -s -n 1
}
astver=$(asterisk -V | grep -woE [0-9]+\.)
pzver=`asterisk -rx"module show like cel_prostiezvonki.so"`

echo "make PZ new backup"
{
mv /backup_vedisoft /backup_vedisoft_old
bash /root/setupmenu/src/vedisoft_b.sh
} &> /dev/null
echo "Downloading new vedisoft version"
{
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk$astver.zip
} &> /dev/null
echo "installing patch"
{
unzip prostiezvonki_asterisk$astver.zip
asterisk -rx"module unload cel_prostiezvonki.so"
rm -rf /usr/lib64/libProtocolLib.so
rm -rf /usr/lib64/asterisk/modules/cel_prostiezvonki.so
cp /root/src/prostiezvonki/so/64/libProtocolLib.so /usr/lib64/
cp /root/src/prostiezvonki/so/64/cel_prostiezvonki.so /usr/lib64/asterisk/modules/
} &> /dev/null
echo "loading module and restart asterisk gracefully"
}
asterisk -rx"module load cel_prostiezvonki.so"
astersk -rx"core restart gracefully"
} &> /dev/null
echo "patch ok, new version $pzver"
end