#!/bin/bash
#This script work with FPBX DISTRO with Centos 6.6+
#This script work only with root priveleges
if [ ! `id -u` = 0 ]; then echo -en "\033[0;31mERROR: script should be started under superuser\n\033[0m"; exit 1; fi
title="Скрипт автоматизации развертывания freepbx"
ver="v5.0"
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m
workdir='/root/setupmenu'
path='/root/setupmenu/src'
scupd='setupmenu.sh'
postfixsetup='postfixsetup.sh'
xtablessetup='xtables_geoip.sh'
autoupdatesys='autoupdatesys.sh'
disablemodules='disablemodules.sh'
freepbxupd='freepbxupd.sh'
statmod='statmod.sh'
celoverwrite='celoverwrite.sh'
isoft='isoft.sh'
prostiezvonki='prostiezvonkiv3.sh'
prostoupd='prostoupd.sh'
missedivrtoemail='missedivrtoemail.sh'
missedreport='missedreport.sh'
callback='callback.sh'
iprules='iprulesv5.sh'
iprulesgeoip='iprulesgeoip.sh'
zvonilka='zvonilka.sh'
websecure='websecure.sh'
selfcert='selfsignedsert.sh'
certcheck='checksslsertificate.sh'
certinst='certificate_install.sh'
certautoupd='certificate_autoupdate.sh'
sshsecure='ssh_secure.sh'
vedisoft_r='vedisoft_r.sh'
vedisoft_b='vedisoft_b.sh'
vedisoft_o='vedisoft_o.sh'
cdrfix='cdrfix.sh'
sngrepupd='sngrepupd.sh'
sql_cf='sql_cf.sh'
cdrfix='cdrfix.sh'
izab='izab.sh'
#####################################
#Функционал разбитый на скрипты
#Обновление скрипта
updatescript()
{
cd $workdir
git fetch
git reset --hard origin
git pull
chmod 777 $workdir/$scupd
repeat=false
sh $0
exit 0
}
#Скрипт настройки postfix для отправки писем с астера
postfixsetup()
{
cd $path
chmod 777 $postfixsetup
sh $postfixsetup
}
#Скрипт установки geoip на iptables
xtablessetup()
{
cd $path
chmod 777 $xtablessetup
sh $xtablessetup
}
#Скрипт настройки автообновления системы
autoupdatesys()
{
cd $path
chmod 777 $autoupdatesys
sh $autoupdatesys
}
#Скрипт отключения ненужных модулей freepbx
disablemodules()
{
cd $path
chmod 777 $disablemodules
sh $disablemodules
}
# Скрипт обновления freepbx
freepbxupd()
{
cd $path
chmod 777 $freepbxupd
sh $freepbxupd
}
# Скрипт установки модуля статистики asternic
statmod()
{
cd $path
chmod 777 $statmod
sh $statmod
}
#Скрипт который переписывает cel.conf
celoverwrite()
{
cd $path
chmod 777 $celoverwrite
sh $celoverwrite
}
# Скрипт установки софта
isoft()
{
cd $path
chmod 777 $isoft
sh $isoft
}
#Скрипт установки простых звонков
prostiezvonki()
{
cd $path
chmod 777 $prostiezvonki
bash $prostiezvonki
}
#Уведомление о пропущенном звонке из групп, очередей и ivr меню
missedivrtoemail()
{
cd $path
chmod 777 $missedivrtoemail
bash $missedivrtoemail
}
#Отчет каждый день на почту о пропущенных звонках в 23:59
missedreport()
{
cd $path
chmod 777 $missedreport
bash $missedreport
}
zvonilka()
{
cd $path
chmod 777 $zvonilka
bash $zvonilka
}
#Настройка callback с сайта
callback()
{
cd $path
chmod 777 $callback
bash $callback
}
#Defending system with additions iptables rules with geoip
iprules()
{
bash $path/$iprules
}
#Реализация change log
changelog()
{
cd $path
cat changelog.txt | less
br
}
#.htaccess для httpd
websecure()
{
cd $path
chmod 777 $websecure
bash $websecure
}
#Создание самоподписанного сертификата
selfcert()
{
cd $path
chmod 777 $selfcert
bash $selfcert
}
#Скрипт который обновляет ssl сертификат простых звонков
certinst()
{
cd $path
chmod 777 $certinst
bash $certinst
}
#Скрипт тупой проверки ssl сертификата
certcheck()
{
cd $path
chmod 777 $certcheck
bash $certcheck
}
#Скрипт настраивает автообновление сертификата простых звонков на каждый месяц.(freepbx сам обновляет сертификат letsencrypt каждые 2 месяца)
certautoupd()
{
cd $path
chmod 777 $certautoupd
bash $certautoupd
}
#Дополнительный скрипт защиты ssh
sshsecure()
{
cd $path
chmod 777 $sshsecure
bash $sshsecure
}
#vedisoft remove
vedisoft_r()
{
bash $path/$vedisoft_r
}
#vedisoft update
vedisoft_o()
{
bash $path/$vedisoft_o
}
#vedisoft backup
vedisoft_b()
{
bash $path/$vedisoft_b
}
#mysql check all databases and fix errors
sql_cf()
{
bash $path/$sql_cf
}
#Repair mysql CDR codepage 
cdrfix()
{
bash $patch/$cdrfix
}
fwdel()
{
echo "FBPX firewall module will be removed"
fwconsole ma remove firewall
fwconsole reload
echo "Done!"
}
fwopennip()
{
echo -e "\nEnter IP(8.8.8.8) or Netwrok(192.168.0.0/24) to allow"
read prov ;
iptables -A INPUT -s $prov -j ACCEPT
save
iptables -vnL
}
fwopenport()
{
echo -e "\nPlease enter the port range(1000:2000) or single port(1234) number to allow" 
read openport ;
echo -e "\nPlease enter protocol(udp/tcp)"
read tcpudp ;
iptables -A INPUT -p $tcpudp -m $tcpudp --dport $openport -j ACCEPT
echo "Done!"
iptables -vnL INPUT | grep $openport
}
########################
########################
########################
#Y/N
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
#Сохранить или нет (для блока Iptables)
save()
{
echo "Применить изменения iptables?"
myread_yn ans
case "$ans" in
 y|Y)
 service iptables save
echo -e "$GREПравила успешно добавлены в iptables и применены!$DEF" ;;
 n|N)
 echo -e "$REDИзменения сделаны, но не применены!$DEF" ;;
 esac
}
#Проверка, установлен пакет или нет
myinstall()
{
if [ -z `rpm -qa $1` ]; then
 yum -y install $1
else
 echo "Пакет $1 уже установлен"
 br
fi
}
#sysinfo
arc=`arch`
if [ "$arc" == "x86_64" ];
then arc=64 #В теории возможно обозначение "IA-64" и "AMD64", но я не встречал
else arc=86 #Чтобы не перебирать все возможные IA-32, x86, i686, i586 и т.д.
fi
#определяем версию ядра Linux
kern=`uname -r | sed -e "s/-/ /" | awk {'print $1'}`
#Заголовок
title()
{
clear
echo -e "$title"
}
#Инфа о freepbx
versionpbx=`cat /etc/schmooze/pbx-version`
versionpbx()
{
clear
echo "$versionpbx"
}
#Версия астериска
astver=$(asterisk -V | grep -woE [0-9]+\.)
#wait
wait()
{
echo -e "$GREНажмите любую клавишу, чтобы продолжить...$DEF"
read -s -n 1
}
#Пустая строка
br()
{
echo ""
}
#Вывод change log
log()
{
changelog
}

##########################################
#Ниже менюхи, привязка фукнционала.
mainmenu=
repeat=true
while [ "$repeat" = "true" ];
do
until [ "$mainmenu" = "0" ];
do
clear
echo -e "┌──────────────────────────────────────────────────┐
 Asterisk $astver Linux $kern x$arc FreePBX $versionpbx
├──────────────────────────────────────────────────┤
  ___                 ___  ___ __  _
 | __> _ _  ___  ___ | . \| . >\ \/
 | _> | '_>/ ._>/ ._>|  _/| . \ \ \
.
 |_|  |_|  \___.\___.|_|  |___/_/\_\
.
  ___         _              __ __
 / __> ___  _| |_  _ _  ___ |  \  \ ___ ._ _  _ _
 \__ \/ ._>  | |  | | || . \|     |/ ._>| ' || | |
 <___/\___.  |_|  \___||  _/|_|_|_|\___.|_|_|\___|
                        |_|
└──────────────────────────────────────────────────┘"
echo -e "
┌──────────────● Главное меню:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Интеграции $RED* $DEF                        │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Настройки $RED* $DEF                         │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Дополнительно $RED* $DEF                     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Настройка безопасности $RED*$DEF             │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ ------------------------------------ │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 6 $DEF│ ------------------------------------ │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 7 $DEF│ ------------------------------------ │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 8 $DEF│ Установить софт                      │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 9 $DEF│ Обновить этот скрипт. $ver           │
│ ├───┼──────────────────────────────────────┤
└─┤$GRE 0 $DEF│ Выход                                │
  └───┴──────────────────────────────────────┘
"
    echo -n "Выберите пункт меню: "
    read -s -n 1 mainmenu
    echo ""
    case $mainmenu in
    1)
    menu1=
    until [ "$menu1" = "0" ]; do
    clear
    echo -e "
┌──────────────● Интеграции:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Установить простые звонки            │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Обновить простые звонки              │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Установить cel.conf                  │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Установить callback                  │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ Установить click2call                │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 6 $DEF│ Установить ssl сертификат            │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 7 $DEF│ Проверить ssl сертификат             │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 8 $DEF│ Интеграция с Slack                   │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 9 $DEF│ Интеграция с Slack и yandex          │
│ ├───┼──────────────────────────────────────┤
└─┤$GRE 0 $DEF│ Выйти в главное меню                 │
  └───┴──────────────────────────────────────┘
"
 echo -n "Выберите пункт меню: "
    read -s -n 1 menu1
    echo ""
    case $menu1 in
    1) prostiezvonki ;;
    2) vedisoft_o ;;
    3) celoverwrite ;;
    4) callback ;;
    5) zvonilka ;;
    6) certinst ;;
    7) certcheck ;;
    8) slackint ;;
    9) slackintwya ;;
    0) mainmenu ;;
    *) echo -e "$REDОшибка, выберите 1-9 или 0$DEF"
    esac
 done
 ;;
2)
 menu2=
 until [ "$menu2" = "0" ]; do
 clear
    echo -e "
┌──────────────● Настройки:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Настроить автоадейт системы          │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Отключить модули FreePBX             │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Обновить FreePBX                     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Настроить Postfix                    │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ Настроить htaccess для httpd         │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 6 $DEF│ Резервная копия ПЗ                   │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 7 $DEF│ Удалить ПЗ                           │
│ ├───┼──────────────────────────────────────┤
└─┤$GRE 0 $DEF│ Выйти в главное меню                 │
  └───┴──────────────────────────────────────┘
"
 echo -n "Выберите пункт меню: "
    read -s -n 1 menu2
    echo ""
    case $menu2 in
 1) autoupdatesys ;;
 2) disablemodules ;;
 3) freepbxupd ;;
 4) postfixsetup ;;
 5) websecure ;;
 6) vedisoft_b ;;
 7) vedisoft_r ;;
 0) mainmenu ;;
 * ) echo "$REDОшибка, выберите 1-7 или 0$DEF"
 esac
 done
 ;;
3)
 menu3=
 until [ "$menu3" = "0" ]; do
 clear
    echo -e "
┌──────────────● Дополнительно:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Отчет о пропущенных на email         │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Установить asternic статистику       │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Проверить sql на ошибки              │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Настроить Доп. защиту ssh            │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ Исправить кодировку CDR              │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 6 $DEF│ Установить Zabbix-agent              │
│ ├───┼──────────────────────────────────────┤
└─┤$GRE 0 $DEF│ Выйти в главное меню                 │
  └───┴──────────────────────────────────────┘
"
 echo -n "Выберите пункт меню: "
    read -s -n 1 menu3
    echo ""
    case $menu3 in
 1) missedreport ;;
 2) statmod ;;
 3) sql_cf ;;
 4) sshsecure ;;
 5) cdrfix ;;
 6) izab ;;
 0) mainmenu ;;
 *) echo "$REDОшибка, выберите 1-3 или 0$DEF"
    esac
 done
 ;;
4)
 menu4=
 until [ "$menu4" = "0" ]; do
 clear
    echo -e "
┌──────────────● Настройка безопасности:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Удалить модуль Firewall из FreePBX   │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Установить GeoIP для IPTABLES        │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Сбросить правила IPTABLES            │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Прописать стандартные правила        │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ Прописать правила защиты             │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 6 $DEF│ Открыть доступ для IP/Сети           │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 7 $DEF│ Открыть Порт или диапазон портов     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 8 $DEF│ Сохранить изменения                  │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 9 $DEF│ Вывести текущие правила              │
│ ├───┼──────────────────────────────────────┤
└─┤$GRE 0 $DEF│ Выйти в главное меню                 │
  └───┴──────────────────────────────────────┘
"
 echo -n "Выберите пункт меню: "
    read -s -n 1 menu4
    echo ""
    case $menu4 in
 1) fwdel
    wait ;;
 2) xtablessetup ;;
 3) iptables -F
    echo "Правила iptables сброшены!"
    wait ;;
 4) iprules ;;
 5) iprulesgeoip ;;
 6) fwopennip
    wait ;;
 7) fwopenport
    wait ;;
 8)
    service iptables save && service iptables restart
    echo "Применяю правила и перезапускаю iptables"
    sleep 3
    echo "Сделано!"
    wait ;;
 9)
    iptables -vnL
    wait ;;
 0) mainmenu ;;
 *) echo "$REDОшибка, выберите 1-9 или 0$DEF"
    esac
 done
 ;;
5) echo -e "$REDempty menu$DEF" ;;
6) echo -e "$REDempty menu$DEF" ;;
7) echo -e "$REDempty menu$DEF" ;;
8) isoft ;;
9) updatescript ;;
0) repeat=false ;;
*) echo "$REDОшибка, выберите 1-9 или 0$DEF"
    esac
 done
done
