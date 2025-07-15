

apt update && apt install -y supervisor sudo curl
supervisord -c /etc/supervisor/supervisord.conf

# Подготовка сервера
echo "Подготовка сервера"
bash <(wget -qO- https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/prep.sh)

# Клонирование репы gensyn rl-swarm и подготовка venv
echo "Клонирование репы gensyn rl-swarm и подготовка venv"
cd && \
git clone https://github.com/gensyn-ai/rl-swarm && \
cd rl-swarm && python3 -m venv .venv

# Скачивание кастомного скрипта на запуск ноды
echo " Скачивание кастомного скрипта на запуск ноды"
curl -o /root/rl-swarm/run_rl_swarm_true.sh https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/run_rl_swarm_true.sh


# Скачивание сервисника
curl -o /etc/supervisor/conf.d/rl-swarm.conf https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/rl-swarm.conf

# Запуск  сервисника и вывод логов
supervisorctl reread
supervisorctl update
supervisorctl start rl-swarm
tail -f /var/log/rl-swarm.out.log -f
