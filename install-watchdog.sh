cd $HOME/rl-swarm && \
wget https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/rl-swarm-watchdog.sh && \
chmod +x rl-swarm-watchdog.sh && \
curl -o /etc/systemd/system/rl-swarm-watchdog.service https://raw.githubusercontent.com/JeTr1x/gensyn-install/refs/heads/main/rl-swarm-watchdog.service && \
systemctl daemon-reload && \
systemctl enable rl-swarm-watchdog.service && \
systemctl start rl-swarm-watchdog.service && \
journalctl -fu rl-swarm-watchdog.service
