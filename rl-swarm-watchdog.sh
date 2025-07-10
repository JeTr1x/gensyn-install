#!/bin/bash

SERVICE="rl-swarm.service"

# Паттерны
ERROR_PATTERN="EOFError: Ran out of input"
API_KEY_PATTERN="Waiting for API key to be activated..."
API_KEY_THRESHOLD=3

# Telegram
TELEGRAM_BOT_TOKEN="7581078853:AAEUyW1GuMeez_1jiQWFqVTlQ_cEImw0m-M"
TELEGRAM_CHAT_ID="-1002856453357"

# Функция отправки алерта

send_telegram_alert() {
    SERVER_IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')

    MESSAGE="⚠️ IP:  \`${SERVER_IP}\`
${API_KEY_PATTERN}"

    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="${MESSAGE}" \
        -d parse_mode="Markdown"
}
while true; do
    echo "[$(date)] Старт проверки логов $SERVICE..."

    ERROR_FOUND=false
    NO_NEW_LOGS=false

    # Проверка на EOFError
    if journalctl -u "$SERVICE" -n 100 --no-pager | grep -q "$ERROR_PATTERN"; then
        echo "[$(date)] Обнаружена ошибка \"$ERROR_PATTERN\"."
        ERROR_FOUND=true
    fi

    # Проверка на отсутствие логов за 30 минут
    if journalctl -u "$SERVICE" --since "30 minutes ago" --no-pager | grep -q -- "-- No entries --"; then
        echo "[$(date)] Нет новых логов за последние 30 минут."
        NO_NEW_LOGS=true
    else
        echo "[$(date)] Логи за последние 30 минут присутствуют."
    fi

    # Проверка на API Key
    API_KEY_COUNT=$(journalctl -u "$SERVICE" -n 30 --no-pager | grep -c "$API_KEY_PATTERN")
    if [[ $API_KEY_COUNT -ge $API_KEY_THRESHOLD ]]; then
        echo "[$(date)] Найдено $API_KEY_COUNT повторений \"$API_KEY_PATTERN\". Отправляем Telegram-алерт..."
        send_telegram_alert
    else
        echo "[$(date)] Повторений \"$API_KEY_PATTERN\" недостаточно ($API_KEY_COUNT)."
    fi

    # Перезапуск при необходимости
    if [[ "$ERROR_FOUND" == true || "$NO_NEW_LOGS" == true ]]; then
        echo "[$(date)] Перезапускаем $SERVICE..."
        systemctl restart "$SERVICE"
    else
        echo "[$(date)] Всё в порядке. Перезапуск не требуется."
    fi

    echo "[$(date)] Жду 30 минут перед следующей проверкой."
    sleep 1800
done
