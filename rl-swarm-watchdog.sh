#!/bin/bash

SERVICE="rl-swarm.service"
ERROR_PATTERN="EOFError: Ran out of input"

while true; do
    echo "[$(date)] Проверка логов на наличие ошибки \"$ERROR_PATTERN\"..."

    ERROR_FOUND=false
    NO_NEW_LOGS=false

    # Проверка на наличие ошибки
    if journalctl -u "$SERVICE" -n 100 --no-pager | grep -q "$ERROR_PATTERN"; then
        echo "[$(date)] Обнаружена ошибка \"$ERROR_PATTERN\"."
        ERROR_FOUND=true
    fi

    # Проверка активности логов за последние 5 минут
    RECENT_LOGS=$(journalctl -u "$SERVICE" --since "5 minutes ago" --no-pager | tail -n 1)
    if [[ -z "$RECENT_LOGS" ]]; then
        echo "[$(date)] Нет новых логов за последние 5 минут."
        NO_NEW_LOGS=true
    fi

    # Условие для перезапуска
    if [[ "$ERROR_FOUND" == true || "$NO_NEW_LOGS" == true ]]; then
        echo "[$(date)] Перезапускаем $SERVICE..."
        systemctl restart "$SERVICE"
    else
        echo "[$(date)] Ошибка не найдена и логи идут. Всё в порядке."
    fi

    echo "[$(date)] Жду 5 мин перед следующей проверкой."
    sleep 300  # 5 минут
done
