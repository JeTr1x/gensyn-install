systemctl stop rl-swarm
rm /root/rl-swarm/userApiKey.json
rm /root/rl-swarm/userData.json
systemctl restart rl-swarm
journalctl -fu rl-swarm
