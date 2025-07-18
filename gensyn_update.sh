
# НЕАКТУАЛЬНО
#CONFIG_NUM=$1


# Клонирование репы gensyn rl-swarm и подготовка venv
echo "Клонирование репы gensyn rl-swarm и подготовка venv"
systemctl stop rl-swarm
cd && \
mkdir -p /root/rlsv3_bak && \
cp /root/rl-swarm/swarm.pem /root/rlsv3_bak/swarm.pem && \
cp /root/rl-swarm/userApiKey.json /root/rlsv3_bak/userApiKey.json && \
cp /root/rl-swarm/userData.json /root/rlsv3_bak/userData.json && \
rm -rf rl-swarm && \
git clone https://github.com/gensyn-ai/rl-swarm && \
cd rl-swarm && python3 -m venv .venv && \
cp /root/rlsv3_bak/swarm.pem /root/rl-swarm/swarm.pem && \
cp /root/rlsv3_bak/userApiKey.json /root/rl-swarm/userApiKey.json && \
cp /root/rlsv3_bak/userData.json /root/rl-swarm/userData.json && \
# Скачивание кастомного скрипта на запуск ноды
echo " Скачивание кастомного скрипта на запуск ноды"
curl -o /root/rl-swarm/run_rl_swarm_true.sh https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/run_rl_swarm_true.sh


# НЕАКТУАЛЬНО
# Скачивание кастомного конфига для ноды 
#curl -o /root/rl-swarm/hivemind_exp/configs/mac/grpo-qwen-2.5-0.5b-deepseek-r1.yaml https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/cpu_config_${CONFIG_NUM}.yaml

# Скачивание сервисника
curl -o /etc/systemd/system/rl-swarm.service https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/rl-swarm.service

# Запуск  сервисника и вывод логов
systemctl daemon-reload && \
systemctl enable rl-swarm.service && \
systemctl start rl-swarm.service && \
journalctl -fu rl-swarm
