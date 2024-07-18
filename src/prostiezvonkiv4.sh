#!/bin/bash
#CRM intgeration master menu
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
end()
{
echo -e "Please press any key"
read -s -n 1
}
#prostie zvonki new
pzinstall()
{
read -p "Пожалуйста вставьте комманду из личного кабинета простых звонков для установки модуля инетграции" PZnew
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
$PZnew  
end
}
#itgrix for amoCRM
ITgro_AMO()
{
mkdir -p /root/src/
cd /root/src/
wget https://itgrix.ru/download/autoinstaller_amo.sh
bash autoinstaller_amo.sh
echo "Itgrix for amoCRM installed"
end
}
#itgrix for bitrix
ITgro_BX()
{
  mkdir -p /root/src/
  cd /root/src/
  wget https://itgrix.ru/download/autoinstaller_bx.sh
  bash autoinstaller_bx.sh
  echo "Itgrix for Bitrix installed"
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
├─┤$GRE 1 $DEF│ Простые звонки (подписка)            │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ itgrix для amoCRM                    │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ itgrix для Bitrix                    │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│                                      │
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
    1) pzinstall ;;
    2) ITgro_AMO ;;
    3) ITgro_BX ;;
    4)  ;;
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
