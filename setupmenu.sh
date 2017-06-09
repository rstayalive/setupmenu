#!/bin/bash
#Скрипт автоматизации развертывания FreePBX
#Пожелания и ошибки кидайте на почту rstayalive@gmail.com
#Этот скрипт поможет вам меньше нажимать кнопок.
#А Так же сократит время настройки в разы.
#Писалось на коленке, так что как то так.
#Обновления выходят тогда, когда находятся ошибки или нужен новый функционал.
#Ну дальше везде каменты есть, разберетесь что к чему.
title="Скрипт автоматизации развертывания freepbx"
ver="Версия 4.2"

#Цвета
RED=\\e[91m
GRE=\\e[92m
DEF=\\e[0m

#Пути на закачку и тд
updpath='https://raw.githubusercontent.com/rstayalive/setupmenu/master/setupmenu.sh'
workdir='/root/setupmenu/'
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
prostiezvonki='prostiezvonki.sh'
missedivrtoemail='missedivrtoemail.sh'
missedreport='missedreport.sh'
callback='callback.sh'
iprulesdef='iprulesdef.sh'
iprulesgeoip='iprulesgeoip.sh'
zvonilka='zvonilka.sh'
websecure='websecure.sh'

#####################################
#Функционал разбитый на скрипты

#Обновление скрипта
updatescript()
{
cd $workdir
git fetch
git reset --hard origin
git pull
chmod 777 $scupd
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
# Скрипт простых звонков
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
#Скрипт установки стандартных правил для FreePBX
iprulesdef()
{
cd $path
chmod 777 $iprulesdef
bash $iprulesdef
}
#Скрипт установки расширеных правил безопасности
iprulesgeoip()
{
cd $path
chmod 777 $iprulesgeoip
bash $iprulesgeoip
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

#Очистка остаточных файлов после работы скрипта
#cleanup()
#{
#cd $workdir
#rm -rf zvonki* postfix* xtables* auto* disable* freepbx* stat* firewall* missed* russian* isoft* prostiezvonki* asternic*  celoverwrite* iprules* callback* click2call*
#}

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
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$title $ver 
Linux $kern x$arc FreePBX $versionpbx
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "
● Главное меню:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Интеграции $RED* $DEF			     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Настройки $RED* $DEF			     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Дополнительно $RED* $DEF		     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Настройка безопасности $RED* $DEF            │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ ------------------------------------ │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 6 $DEF│ ------------------------------------ │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 7 $DEF│ Установить софт			     │ 
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 8 $DEF│ Что нового			     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 9 $DEF│ Обновить этот скрипт		     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 0 $DEF│ Выход			   	     │
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
● Интеграции:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Установить простые звонки	     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Создать сертификат		     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Установить cel.conf                  │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Установить callback		     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ Установить click2call		     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 0 $DEF│ Выйти в главное меню		     │
  └───┴──────────────────────────────────────┘
"		
	echo -n "Выберите пункт меню: "
    read -s -n 1 menu1
    echo ""
    case $menu1 in
		1) prostiezvonki ;;
		2) 
			cd /etc/asterisk
			echo "Создаю самоподписанный сертификат для простых звонков"
		mv dh512.pem dh512.pem_back
        openssl dhparam -out dh512.pem 2048
        echo "Создаю новый сертификат"
		openssl req -new -x509 -days 1095 -newkey rsa:1024 -sha256 -nodes -keyform PEM -keyout privkey1.pem -outform PEM -out newsert.pem -config <(echo -e '[req]\nprompt=no\nreq_extensions=req_ext\ndistinguished_name=dn\n[dn]\nC=RU\nST=Russia\nL=Moscow\nO=vedisoft\nOU=prostiezvonki\nCN=asterisk\n[req_ext]\nsubjectAltName=DNS:asterisk') -extensions req_ext
			echo -e "$GREВсе готово!$DEF"
			wait ;;
		3) celoverwrite ;;
		4) callback ;;
		5) zvonilka ;;
		0) mainmenu ;;
		*) echo "$REDОшибка, выберите 1-5 или 0$DEF"
    esac
	done
	;;
2)
	menu2=
	until [ "$menu2" = "0" ]; do
	clear
    echo -e "
● Настройки:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Настроить автоадейт системы 	     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Отключить модули FreePBX	     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Обновить FreePBX	  	     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 4 $DEF│ Настроить Postfix       	     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 5 $DEF│ Настроить htaccess для httpd 	     │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 0 $DEF│ Выйти в главное меню                 │
  └───┴──────────────────────────────────────┘
"
	echo -n "Выберите пункт меню: "
    read -s -n 1 menu2
    echo ""
    case $menu2 in
	1) autoupdatesys ;;
	2) disablemodules ;;
	3) freepbxupd ;;
	4) postfixsetup;;
	5) websecure;;
	0) mainmenu ;;
	* ) echo "$REDОшибка, выберите 1-5 или 0$DEF"
	esac
	done	
	;;
3)
	menu3=
	until [ "$menu3" = "0" ]; do
	clear
    echo -e "
● Дополнительно:
│
│ ┌───┬──────────────────────────────────────┐
├─┤$GRE 1 $DEF│ Отчет о пропущенных на email         │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 2 $DEF│ Установить asternic статистику       │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 3 $DEF│ Настроить пропущенный с ivr на email │
│ ├───┼──────────────────────────────────────┤
├─┤$GRE 0 $DEF│ Выйти в главное меню                 │
  └───┴──────────────────────────────────────┘
"	
	echo -n "Выберите пункт меню: "
    read -s -n 1 menu3
    echo ""
    case $menu3 in
	1) missedreport ;;
	2) statmod ;;
	3) missedivrtoemail ;;
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
● Дополнительно:
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
├─┤$GRE 0 $DEF│ Выйти в главное меню                 │
  └───┴──────────────────────────────────────┘
"
	echo -n "Выберите пункт меню: "
    read -s -n 1 menu4
    echo ""
    case $menu4 in
	1) 
		echo "Удаляю модуль Firewall из FreePBX"
		fwconsole ma remove firewall
		fwconsole reload
		fwconsole ma list | grep firewall
		echo "Готово!"
		wait ;;
	2) xtablessetup ;;
	3) iptables -F 
		echo "Правила iptables сброшены!"
		wait ;;
	4) iprulesdef ;;
	5) iprulesgeoip ;;
	6) 
		echo -e "\nВведите IP или Сеть формат - 8.8.8.8 или 192.168.0.0/24"
		read prov ;
		iptables -A INPUT -s $prov -j ACCEPT
		save
		iptables -L -v -n
		wait ;;
	7) 
		echo -e "\nВведите порт или диапазон портов который нужно открыть, формат 5060:5160 (откроет с 5060 по 5160)"
		read openport ;
		echo -e "\nВведите протокол udp или tcp"
		read tcpudp ;
		iptables -A INPUT -p $tcpudp -m $tcpudp --dport $openport -j ACCEPT
		echo "Готово!"
		iptables -L -v -n
		wait ;;
	8) 
		service iptables save && service iptables restart 
		echo "Применяю правила и перезапускаю iptables"
		sleep 3 
		echo "Сделано!"
		wait ;;
	9) 
		iptables -L -v -n 
		wait ;;
	0) mainmenu ;;
	*) echo "$REDОшибка, выберите 1-7 или 0$DEF"
    esac
	done	
	;;		
5) echo -e "$REDempty menu$DEF" ;;
6) echo -e "$REDempty menu$DEF" ;;
7) isoft ;;
8) 
	clear
	changelog 
	wait ;;
9) updatescript ;;
0) repeat=false ;;
*) echo "$REDОшибка, выберите 1-9 или 0$DEF"
    esac
	done
done