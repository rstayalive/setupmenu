#!/bin/bash

# Путь к конфигурационному файлу
CONFIG_FILE="/etc/freepbx.conf"

# Извлечение параметров из файла
DB_USER=$(grep -oP '\$amp_conf\["AMPDBUSER"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_PASS=$(grep -oP '\$amp_conf\["AMPDBPASS"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_HOST=$(grep -oP '\$amp_conf\["AMPDBHOST"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_PORT=$(grep -oP '\$amp_conf\["AMPDBPORT"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_NAME=$(grep -oP '\$amp_conf\["AMPDBNAME"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)

# Проверка подключения к базе данных
if mysql -u"$DB_USER" -p"$DB_PASS" -h"$DB_HOST" -P"$DB_PORT" -e "USE $DB_NAME;" >/dev/null 2>&1; then
    echo "Подключение к базе данных $DB_NAME успешно!"
else
    echo "Ошибка подключения к базе данных $DB_NAME."
    exit 1
fi

echo "u=$DB_USER p=$DB_PASS"
