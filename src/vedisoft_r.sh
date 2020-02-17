#!/bin/bash
#удаление модуля простых звонков
#end
end()
{
echo -e "Нажмите любую клавишу чтобы вернуться в меню"
read -s -n 1
}

echo "Начинаю удалять модуль простых звонков"
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
echo "Модуль успешно удален!"
end
