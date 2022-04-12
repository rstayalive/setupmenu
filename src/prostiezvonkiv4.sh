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
astauto()
{
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk$astver.zip
unzip prostiezvonki_asterisk$astver.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
echo "PZ installed to asterisk $astver"
end
}
ast18()
{
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk18.zip
unzip prostiezvonki_asterisk18.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
echo "PZ installed to asterisk 18"
end
}
ast16()
{
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk16.zip
unzip prostiezvonki_asterisk16.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
echo "PZ installed to asterisk 16"
end
}
ast13()
{
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk13.zip
unzip prostiezvonki_asterisk13.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
echo "PZ installed to asterisk 13"
end
}
ast11()
{
mkdir -p /root/src/
cd /root/src/
wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk11.zip
unzip prostiezvonki_asterisk13.zip
cd prostiezvonki
bash install
fwconsole ma install prostiezvonki
fwconsole reload
fwconsole chown
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
echo "PZ installed to asterisk 11"
end
}
ITgro()
{
yum install qt5-qtwebsockets.x86_64 qt5-qtwebsockets-devel.x86_64 qt5-qtbase-mysql.x86_64
mkdir -p /root/src/
cd /root/src/
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
├─┤$GRE 1 $DEF│ PZ Версия для 18 астериска           │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ PZ Версия для 16 астериска           │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ PZ Версия для 13 астериска           │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ PZ Автоопределение                   │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ ITgro                                │
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
    1) ast18 ;;
    2) ast16 ;;
    3) ast13 ;;
    4) astauto ;;
    5) ITgro ;;
    6)  ;;
    7)  ;;
    8)  ;;
    9)  ;;
    0) repeat=false ;;
    *) echo -e "$REDОшибка, выберите 1-9 или 0$DEF"
    esac
done
done
