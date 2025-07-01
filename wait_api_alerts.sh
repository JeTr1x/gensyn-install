#!/bin/bash

SERVICE="rl-swarm.service"
PATTERN="Waiting for API key to be activated..."
THRESHOLD=3

# Телеграм параметры
TELEGRAM_BOT_TOKEN="123456789:ABCDEF-YOUR-BOT-TOKEN"
TELEGRAM_CHAT_ID="123456789"

# Функция отправки алерта
send_telegram_alert() {
    MESSAGE="⚠️ [$HOSTNAME] Обнаружено $THRESHOLD+ повторений: \"$PATTERN\" в логах $SERVICE"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="${MESSAGE}"
}

# Основной цикл
while true; do
    echo "[$(date)] Проверка логов $SERVICE..."

    COUNT=$(journalctl -u "$SERVICE" -n 30 --no-pager | grep -c "$PATTERN")

    if [[ $COUNT -ge $THRESHOLD ]]; then
        echo "[$(date)] Найдено $COUNT повторений \"$PATTERN\". Отправляем Telegram-алерт..."
        send_telegram_alert
    else
        echo "[$(date)] Повторений недостаточно ($COUNT)."
    fi

    sleep 300  # Пауза 5 минут
done
