#!/bin/bash
#CRM and asterisk intgration menu
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
end()
{
echo -e "Please press any key"
read -s -n 1
}
astver=$(asterisk -V | grep -woE [0-9]+\.)
ast16()
{
cd /tmp
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk16.zip
unzip prostiezvonki_asterisk13.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk$astver.zip
echo "PZ installed to asterisk $astver"
end
}
ast13()
{
cd /tmp
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk13.zip
unzip prostiezvonki_asterisk13.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk$astver.zip
echo "PZ installed to asterisk $astver"
end
}
ast11()
{
cd /tmp
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk11.zip
unzip prostiezvonki_asterisk13.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk$astver.zip
echo "PZ installed to asterisk $astver"
end
}
ITgro()
{
yum install qt5-qtwebsockets.x86_64 qt5-qtwebsockets-devel.x86_64 qt5-qtbase-mysql.x86_64
cd /tmp
curl -k -O https://bx24asterisk.ru/download/autoinstaller_amo.sh
bash autoinstaller_amo.sh
echo "ITgro installed"
end
}

menu1=
repeat=true
while [ "$repeat" = "true" ];
do
until [ "$menu1" = "0" ]; do
clear
echo -e "
┌──────────────● Выберите Коннектор:
│  Версия вашего астериска: $astver
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ PZ Версия для 16 астериска           │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ PZ Версия для 13 астериска           │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ PZ Версия для 11 астериска           │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ ITgro                                │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│                                      │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 6 $DEF│                                      │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 7 $DEF│                                      │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 8 $DEF│                                      │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 9 $DEF│                                      │
│ ├───┼──────────────────────────────────────┤
└─┤$GRE 0 $DEF│ Выйти из меню                        │
  └───┴──────────────────────────────────────┘
"
 echo -n "Выберите пункт меню: "
    read -s -n 1 menu1
    echo ""
    case $menu1 in
    1) ast16 ;;
    2) ast13 ;;
    3) ast11 ;;
    4) ITgro ;;
    5)  ;;
    6)  ;;
    7)  ;;
    8)  ;;
    9)  ;;
    0) repeat=false ;;
    *) echo -e "$REDОшибка, выберите 1-9 или 0$DEF"
    esac
done
done
