#!/bin/bash

SERVICE="rl-swarm.service"
ERROR_PATTERN="EOFError: Ran out of input"

while true; do
    echo "[$(date)] Проверка логов на наличие ошибки \"$ERROR_PATTERN\"..."

    if journalctl -u "$SERVICE" -n 100 --no-pager | grep -q "$ERROR_PATTERN"; then
        echo "[$(date)] Обнаружена ошибка \"$ERROR_PATTERN\", перезапускаем $SERVICE"
        systemctl restart "$SERVICE"
    else
        echo "[$(date)] Ошибка не найдена. Всё в порядке."
    fi

    sleep 300  # 5 минут
done
