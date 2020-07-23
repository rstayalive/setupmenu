#!/bin/bash
#vedisoft update module
end()
{
echo -e "Please press any key"
read -s -n 1
}
mkbackup()
{
bash /root/setupmenu/src/vedisoft_b.sh
}
cinfo()
{
grep password /etc/asterisk/cel_prostiezvonki.conf >> /backup_vedisoft/conf.txt
grep record_external_path /etc/asterisk/cel_prostiezvonki.conf >> /backup_vedisoft/conf.txt
grep contract /etc/asterisk/cel_prostiezvonki.conf >> /backup_vedisoft/conf.txt
grep channel_type /etc/asterisk/cel_prostiezvonki.conf >> /backup_vedisoft/conf.txt
}
astver=$(asterisk -V | grep -woE [0-9]+\.)
echo "Making PZ new backup."
{
if ! [ -d "/backup_vedisoft" ];
then
mkbackup
else
mv /backup_vedisoft /backup_vedisoft_old
mkbackup
fi
} &> /dev/null
echo "Getting some settings from PZ conf..."
cinfo
echo "Done. Some setting exported from conf saved here /backup_vedisoft/conf.txt."
echo "Downloading new PZ version."
{
mkdir -p /root/srcPZ/
cd /root/srcPZ/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk$astver.zip
} &> /dev/null
echo "Installing patch."
{
unzip prostiezvonki_asterisk$astver.zip
asterisk -rx"module unload cel_prostiezvonki.so"
rm -rf /usr/lib64/libProtocolLib.so
rm -rf /usr/lib64/asterisk/modules/cel_prostiezvonki.so
cp /root/srcPZ/prostiezvonki/so/64/libProtocolLib.so /usr/lib64/
cp /root/srcPZ/prostiezvonki/so/64/cel_prostiezvonki.so /usr/lib64/asterisk/modules/
} &> /dev/null
echo "Loading module and restart asterisk gracefully."
{
asterisk -rx"module load cel_prostiezvonki.so"
asterisk -rx"core restart gracefully"
} &> /dev/null
sleep 6
pzver=`asterisk -rx"module show like cel_prostiezvonki.so"`
echo "Path installed. New version of running $pzver"
end