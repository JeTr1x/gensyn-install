

# НЕАКУТАЛЬНО
# Переменная для конфига прим. bash gensyn_reinstall.sh 2
#CONFIG_NUM=$1
# Остановка сервиса; удаление файлов
systemctl stop rl-swarm.service && \
rm -rf /root/rl-swarm


# Подготовка сервера / SKIP
echo "Подготовка сервера"
bash <(wget -qO- https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/prep.sh)


# Клонирование репы gensyn rl-swarm и подготовка venv
echo "Клонирование репы gensyn rl-swarm и подготовка venv"
cd && \
git clone https://github.com/gensyn-ai/rl-swarm && \
cd rl-swarm && git checkout v0.5.5 && python3 -m venv .venv
source /root/rl-swarm/.venv/bin/activate && pip install --force-reinstall transformers==4.51.3 trl==0.19.1

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
