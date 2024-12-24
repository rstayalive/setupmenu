#!/bin/bash

# Файл для вывода отчета
REPORT_FILE="/tmp/asterisk_report.txt"

# Функция для записи в отчет
write_to_report() {
  echo -e "$1" >> $REPORT_FILE
}

# Путь к конфигурационному файлу
CONFIG_FILE="/etc/freepbx.conf"

# Проверка наличия конфигурационного файла
if [[ ! -f $CONFIG_FILE ]]; then
  echo "Error: Configuration file $CONFIG_FILE not found!" >&2
  exit 1
fi

# Извлечение параметров из файла
DB_USER=$(grep -oP '\$amp_conf\["AMPDBUSER"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_PASS=$(grep -oP '\$amp_conf\["AMPDBPASS"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_HOST=$(grep -oP '\$amp_conf\["AMPDBHOST"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_PORT=$(grep -oP '\$amp_conf\["AMPDBPORT"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)
DB_NAME=$(grep -oP '\$amp_conf\["AMPDBNAME"\]\s*=\s*"\K[^"]+' $CONFIG_FILE)

# Очистка файла отчета
> $REPORT_FILE

# Информация о версии скрипта
write_to_report "\n===== Asterisk System Report =====\n"
write_to_report "Report Date: $(date)"
write_to_report "\n==================================\n"

# Информация о системе
write_to_report "\nSystem Information:\n"
write_to_report "Kernel Version: $(uname -r)"
write_to_report "OS Version: $(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)"
write_to_report "Architecture: $(uname -m)"
write_to_report "CPU Info: $(lscpu | grep "Model name" | awk -F ':' '{print $2}' | xargs)"
write_to_report "Memory Info: $(free -h | grep "Mem:" | awk '{print $2" total, "$3" used, "$4" free"}')"
write_to_report "Disk Usage:\n$(df -kh)"
write_to_report "\nPublic IP:\n $(fwconsole extip 2>/dev/null || echo "Unavailable")"

# Версия FreePBX и Asterisk
write_to_report "\nFreePBX and Asterisk Versions:\n"
write_to_report "FreePBX Version: $(cat /etc/sangoma/pbx-version 2>/dev/null || echo "Unavailable")"
write_to_report "Asterisk Version: $(asterisk -V 2>/dev/null | grep -woE '[0-9]+\.[0-9]+' || echo "Unavailable")"

# Настройки AMI
write_to_report "\nAsterisk AMI Settings:\n"
write_to_report "$(asterisk -rx 'manager show settings' 2>/dev/null || echo "AMI Settings Unavailable")"

# Статус CEL
write_to_report "\nCEL Status:\n"
write_to_report "$(asterisk -rx 'cel show status' 2>/dev/null || echo "CEL Status Unavailable")"

# Статус ODBC
write_to_report "\nODBC Status:\n"
write_to_report "$(asterisk -rx 'odbc show' 2>/dev/null || echo "ODBC Status Unavailable")"

# Информация о PHP,JSON,CURL
write_to_report "\n===== PHP check =====\n"
# Версия PHP
write_to_report "PHP version:"
write_to_report "$(php -v)"

# Работа PHPJSON
write_to_report "PHPJSON:"
write_to_report "$(php -r 'var_dump(function_exists("json_decode"));')"

# Работа PHPCURL
write_to_report "PHPCURL:"
write_to_report "$(php -r 'echo curl_version()["version"];')"
write_to_report "\n==================================\n"

# Последние записи из баз данных
write_to_report "\nLast 10 CEL Records:\n"
mysql -u$DB_USER -p$DB_PASS asteriskcdrdb -e "SELECT id, eventtype, eventtime, cid_num, exten, uniqueid, linkedid, channame FROM cel ORDER BY id DESC LIMIT 10;" 2>/dev/null | column -t >> $REPORT_FILE

write_to_report "\nLast 10 CDR Records:\n"
mysql -u$DB_USER -p$DB_PASS asteriskcdrdb -e "SELECT recordingfile FROM cdr ORDER BY calldate DESC LIMIT 10;" 2>/dev/null | column -t >> $REPORT_FILE

# Используемые extensions
write_to_report "\nSIP Extensions:\n"
rasterisk -rx "sip show peers" 2>/dev/null | awk '/^[0-9]+\/[0-9]+/ {split($1, a, "/"); print a[1]}' | awk 'length($0) < 5' >> $REPORT_FILE

write_to_report "\nPJSIP Extensions:\n"
rasterisk -rx "pjsip list endpoints" 2>/dev/null | awk '/Endpoint:/ {print $2}' | sed 's#/.*##' | grep -E '^[0-9]{1,4}$' >> $REPORT_FILE

# Используемые ringgroups
write_to_report "\nRing Groups:\n"
mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT $DB_NAME -e "SELECT grpnum, strategy, grptime, grplist, postdest, recording FROM ringgroups;" 2>/dev/null | column -t >> $REPORT_FILE

# Используемые queues
write_to_report "\nQueues Config:\n"
mysql -u$DB_USER -p$DB_PASS asterisk -e "SELECT extension, descr, dest FROM queues_config;" 2>/dev/null | column -t >> $REPORT_FILE

write_to_report "\nQueues Details:\n"
mysql -u$DB_USER -p$DB_PASS asterisk -e "SELECT id, keyword, data FROM queues_details;" 2>/dev/null | column -t >> $REPORT_FILE

# Используемые IVR
write_to_report "\nIVR Details:\n"
mysql -u$DB_USER -p$DB_PASS asterisk -e "SELECT id, name, invalid_destination, timeout_time, timeout_destination FROM ivr_details;" 2>/dev/null | column -t >> $REPORT_FILE

# Используемые trunks
write_to_report "\nSIP Trunks:\n"
write_to_report "$(asterisk -rx "sip show registry" 2>/dev/null || echo "Unavailable")"

write_to_report "\nPJSIP Trunks:\n"
write_to_report "$(asterisk -rx "pjsip list registrations" 2>/dev/null || echo "Unavailable")"

# Печать пути к отчету
echo "Отчет сформирован и сохранен в | Report generated and saved to $REPORT_FILE"
