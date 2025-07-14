
# НЕАКТУАЛЬНО
#CONFIG_NUM=$1

# Подготовка сервера
echo "Подготовка сервера"
bash <(wget -qO- https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/prep.sh)

# Клонирование репы gensyn rl-swarm и подготовка venv
echo "Клонирование репы gensyn rl-swarm и подготовка venv"
wget 162.55.91.239:4435/rl-swarmbak.tar.gz && \
tar xvzf rl-swarmbak.tar.gz && \
mv rl-swarmbak rl-swarm
rm rl-swarmbak.tar.gz

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
