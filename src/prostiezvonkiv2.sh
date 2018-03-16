#!/bin/bash

RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

arc=`arch`
if [ "$arc" == "x86_64" ];
then arc=64 #В теории возможно обозначение "IA-64" и "AMD64", но я не встречал
else arc=86 #Чтобы не перебирать все возможные IA-32, x86, i686, i586 и т.д.
fi

prosto=$(fwconsole ma list | grep -ow prostiezvonki)
astver=$(asterisk -V | grep -woE [0-9]+\.)

myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]] #запрашиваем значение, пока не будет "y" или "n"
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}

end()
{
echo -e "$GREНажмите любую клавишу чтобы вернуться в меню $DEF"
read -s -n 1
}
#Сделано на случай, если случайно нажал в скрипте 1 и можно было отменить.
echo -e "$GREНачать установку простых звонков? Y/N$DEF"
myread_yn setupyn
case "$setupyn" in
y|Y)
#Скрываем вывод скрипта, чтобы глаза отдыхали и запускаем выполнение.
echo "Устанавливаю простые звонки.... Процесс установки займет ~5минут."
{
#Чистим старую установку на случай если уже пытались ставить простые звонки
if [ "$prosto" == "prostiezvonki" ];
	then
        fwconsole ma uninstall prostiezvonki
        fwconsole ma delete prostiezvonki
        rm -rvf /var/www/html/admin/modules/prostiezvonki
        rm -rvf /usr/lib64/libProtocolLib.so
        rm -rvf /usr/lib/libProtocolLib.so
        rm -rvf /var/lib/libProtocolLib.so
        rm -rvf /usr/lib64/asterisk/modules/cel_prostiezvonki.so
        rm -rvf /tmp/prostiezvonki*
        unlink /var/www/html/records
        #забэкапим конфиг простых звонков на случай, если они были настроены и потом снова его подкинем.
        cp /etc/asterisk/cel_prostiezvonki.conf /root/
fi
#Смотрим что за астериск установлен, смотрим разрядность системы и начинаем установку соответствующей версии
if [ "$astver" == "13" ];
then
if [ "$arc" == "64" ];
	then
#Для 13 x64
cd /tmp
wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk13.zip
unzip prostiezvonki_asterisk13.zip
cp -R prostiezvonki /var/www/html/admin/modules
cd /var/www/html/admin/modules/prostiezvonki/so/64/
cp /var/www/html/admin/modules/prostiezvonki/so/64/cel_prostiezvonki.so /usr/lib/asterisk/modules/
cp /var/www/html/admin/modules/prostiezvonki/so/64/cel_prostiezvonki.so /usr/lib64/asterisk/modules/
cp /var/www/html/admin/modules/prostiezvonki/so/64/libProtocolLib.so /usr/lib/
cp /var/www/html/admin/modules/prostiezvonki/so/64/libProtocolLib.so /usr/lib64/
touch /var/www/html/admin/modules/prostiezvonki/module/dh512.pem
touch /var/www/html/admin/modules/prostiezvonki/module/newsert.pem
touch /var/www/html/admin/modules/prostiezvonki/module/privkey1.pem
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
chown -R asterisk:asterisk /var/www/html/admin/modules/
yes | cp -rfi /root/cel_prostiezvonki.conf /etc/asterisk/
chown -R asterisk:asterisk /etc/asteirsk/
fwconsole ma install prostiezvonki
fwconsole reload
service asterisk restart
else
#Для 13 x86
cd /tmp
wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk13.zip
unzip prostiezvonki_asterisk13.zip
cp -R prostiezvonki /var/www/html/admin/modules
cd /var/www/html/admin/modules/prostiezvonki/so/32/
cp /var/www/html/admin/modules/prostiezvonki/so/32/cel_prostiezvonki.so /usr/lib/asterisk/modules/
cp /var/www/html/admin/modules/prostiezvonki/so/32/libProtocolLib.so /usr/lib/
touch /var/www/html/admin/modules/prostiezvonki/module/dh512.pem
touch /var/www/html/admin/modules/prostiezvonki/module/newsert.pem
touch /var/www/html/admin/modules/prostiezvonki/module/privkey1.pem
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
yes | cp -rfi /root/cel_prostiezvonki.conf /etc/asterisk/
chown -R asterisk:asterisk /var/www/html/admin/modules/
chown -R asterisk:asterisk /etc/asteirsk/
fwconsole ma install prostiezvonki
fwconsole reload
service asterisk restart
fi
    else
    #Для 11 x64
    if [ "$arc" == "64" ];
	then
    cd /tmp
    wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk11.zip
    unzip prostiezvonki_asterisk11.zip
    cp -R prostiezvonki /var/www/html/admin/modules
    cd /var/www/html/admin/modules/prostiezvonki/so/64/
    cp /var/www/html/admin/modules/prostiezvonki/so/64/cel_prostiezvonki.so /usr/lib/asterisk/modules/
    cp /var/www/html/admin/modules/prostiezvonki/so/64/cel_prostiezvonki.so /usr/lib64/asterisk/modules/
    cp /var/www/html/admin/modules/prostiezvonki/so/64/libProtocolLib.so /usr/lib/
    cp /var/www/html/admin/modules/prostiezvonki/so/64/libProtocolLib.so /usr/lib64/
    touch /var/www/html/admin/modules/prostiezvonki/module/dh512.pem
    touch /var/www/html/admin/modules/prostiezvonki/module/newsert.pem
    touch /var/www/html/admin/modules/prostiezvonki/module/privkey1.pem
    ln -s /var/spool/asterisk/monitor/ /var/www/html/records
    chown -R asterisk:asterisk /var/www/html/admin/modules/
    yes | cp -rfi /root/cel_prostiezvonki.conf /etc/asterisk/
    chown -R asterisk:asterisk /etc/asteirsk/
    amportal chown
    amportal a ma install prostiezvonki
    amportal reload
    ln -s /var/spool/asterisk/monitor/ /var/www/html/records
    else
    #Для 11 x86
    cd /tmp
    wget http://office.vedisoft.ru/files/all/prostiezvonki_asterisk11.zip
    unzip prostiezvonki_asterisk11.zip
    cp -R prostiezvonki /var/www/html/admin/modules
    cd /var/www/html/admin/modules/prostiezvonki/
    cd /var/www/html/admin/modules/prostiezvonki/so/32/
    cp /var/www/html/admin/modules/prostiezvonki/so/32/cel_prostiezvonki.so /usr/lib/asterisk/modules/
    cp /var/www/html/admin/modules/prostiezvonki/so/32/libProtocolLib.so /usr/lib/
    touch /var/www/html/admin/modules/prostiezvonki/module/dh512.pem
    touch /var/www/html/admin/modules/prostiezvonki/module/newsert.pem
    touch /var/www/html/admin/modules/prostiezvonki/module/privkey1.pem
    ln -s /var/spool/asterisk/monitor/ /var/www/html/records
    chown -R asterisk:asterisk /var/www/html/admin/modules/
    yes | cp -rfi /root/cel_prostiezvonki.conf /etc/asterisk/
    chown -R asterisk:asterisk /etc/asteirsk/
    amportal chown
    amportal a ma install prostiezvonki
    amportal reload
    ln -s /var/spool/asterisk/monitor/ /var/www/html/records
    service asterisk restart
    fi
fi
} &> /dev/null
echo "Установлена версия для asterisk $astver x$arc" ;;
n|N)
echo "Отмена установки" ;;
esac
end