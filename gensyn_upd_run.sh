


# Скачивание кастомного скрипта на запуск ноды
echo " Скачивание кастомного скрипта на запуск ноды"
systemctl stop rl-swarm
curl -o /root/rl-swarm/run_rl_swarm_true.sh https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/run_rl_swarm_true.sh

rm /root/rl-swarm/userApiKey.json /root/rl-swarm/userData.json && systemctl restart rl-swarm
journalctl -fu rl-swarm

