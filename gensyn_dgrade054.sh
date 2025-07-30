

# НЕАКУТАЛЬНО
# Переменная для конфига прим. bash gensyn_reinstall.sh 2
#CONFIG_NUM=$1

# Подготовка сервера / SKIP
# echo "Подготовка сервера"
# bash <(wget -qO- https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/prep.sh)


# Остановка сервиса; удаление файлов
systemctl stop rl-swarm.service

# Клонирование репы gensyn rl-swarm и подготовка venv

cd && \
mkdir -p /root/rlsv8_bak && \
cp /root/rl-swarm/swarm.pem /root/rlsv8_bak/swarm.pem && \
cp /root/rl-swarm/userApiKey.json /root/rlsv8_bak/userApiKey.json && \
cp /root/rl-swarm/userData.json /root/rlsv8_bak/userData.json && \
rm -rf rl-swarm && \
git clone https://github.com/gensyn-ai/rl-swarm && \
cd rl-swarm && git checkout v0.5.4 && python3 -m venv .venv && \
source /root/rl-swarm/.venv/bin/activate && pip install --force-reinstall transformers==4.51.3 trl==0.19.1
cp /root/rlsv8_bak/swarm.pem /root/rl-swarm/swarm.pem && \
cp /root/rlsv8_bak/userApiKey.json /root/rl-swarm/userApiKey.json && \
cp /root/rlsv8_bak/userData.json /root/rl-swarm/userData.json
# Скачивание кастомного скрипта на запуск ноды
echo " Скачивание кастомного скрипта на запуск ноды"
curl -o /root/rl-swarm/run_rl_swarm_true.sh https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/run_rl_swarm_true.sh


# НЕАКУТАЛЬНО
# Скачивание кастомного конфига для ноды
# curl -o /root/rl-swarm/hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/cpu_config_${CONFIG_NUM}.yaml

# Скачивание сервисника
curl -o /etc/systemd/system/rl-swarm.service https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/rl-swarm.service

# Запуск  сервисника и вывод логов
systemctl daemon-reload && \
systemctl enable rl-swarm.service && \
systemctl start rl-swarm.service && \
journalctl -fu rl-swarm
