#!/bin/bash
#скрипт копирования черного списка freepbx в fmc номера itgrix, для игнорирования номеров черного списка.

# --- Настройки ---
ITGRIX_FILE="/etc/itgrix_bx/fmc_patterns.txt"
TEMP_BLACKLIST="/tmp/freepbx_blacklist.txt"

# --- 1. Получаем номера из blacklist через Asterisk CLI ---
# Более надежный парсинг: берем только то, что между /blacklist/ и пробелом
asterisk -x "database show blacklist" | grep "^/blacklist/" | sed 's|^/blacklist/||' | awk '{print $1}' | grep -E '^[0-9]+$' > "$TEMP_BLACKLIST"

# Проверяем, есть ли результат
if [ ! -s "$TEMP_BLACKLIST" ]; then
    echo "Предупреждение: В Blacklist FreePBX нет номеров."
fi

# --- 2. Добавляем номера в файл itgrix ---
# Создаем резервную копию
if [ -f "$ITGRIX_FILE" ]; then
    cp "$ITGRIX_FILE" "$ITGRIX_FILE.bak"
    echo "Создана резервная копия: $ITGRIX_FILE.bak"
fi

ADDED_COUNT=0

while IFS= read -r number; do
    if [ -z "$number" ]; then
        continue
    fi

    # Проверяем, нет ли уже такого номера в файле
    if ! grep -Fxq "$number" "$ITGRIX_FILE"; then
        echo "$number" >> "$ITGRIX_FILE"
        echo "Добавлен номер: $number"
        ((ADDED_COUNT++))
    fi
done < "$TEMP_BLACKLIST"

# --- 3. Очистка ---
rm -f "$TEMP_BLACKLIST"

echo "-------------------------------------"
echo "Готово! Добавлено новых номеров: $ADDED_COUNT"
echo "Обновленный файл: $ITGRIX_FILE"