#!/bin/bash
#инсталяция простых звонков с помощью инсталятора простых звонков

prosto=$(fwconsole ma list | grep -ow prostiezvonki)
astver=$(asterisk -V | grep -woE [0-9]+\.)

#end
end()
{
echo -e "Нажмите любую клавишу чтобы вернуться в меню"
read -s -n 1
}

if [ "$astver" == "13" ];
then
    cd /tmp
    wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk13.zip
    unzip prostiezvonki_asterisk13.zip
    cd prostiezvonki
    bash install
    fwconsole ma install prostiezvonki
    fwconsole reload
    fwconsole chown
    echo "Установлены простые звонки для asterisk $astver"
else
    cd /tmp
    wget http://prostiezvonki.ru/installs/prostiezvonki_asterisk11.zip
    unzip rostiezvonki_asterisk11.zip
    cd rostiezvonki
    bash install
    amportal a ma install prostiezvonki
    amportal reload
    amportal chown
    echo "Установлены простые звонки для asterisk $astver"
fi
#Создаем символьную ссылку для записей
ln -s /var/spool/asterisk/monitor/ /var/www/html/records
end