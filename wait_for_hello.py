import subprocess
import re

# Название сервиса systemd
SERVICE_NAME = "rl-swarm.service"
# Куда сохранять результат
OUTPUT_FILE = "/root/rl-swarm/rl_swarm_identity.txt"

# Регулярка для нужной строки
pattern = re.compile(
    r"Hello.*\[(.*?)\].*\[(Qm[a-zA-Z0-9]{44})\]"
)

def follow_logs():
    # journalctl -u rl-swarm.service -f -n 0
    process = subprocess.Popen(
        ["journalctl", "-u", SERVICE_NAME, "-f", "-n", "0"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )
    print(f"🕵️ Ожидание строки от сервиса {SERVICE_NAME}...")

    for line in process.stdout:
        match = pattern.search(line)
        if match:
            nickname, node_id = match.groups()
            print(f"✅ Найдено! nickname: {nickname}, node_id: {node_id}")
            with open(OUTPUT_FILE, "w") as f:
                f.write(f"{nickname}:{node_id}\n")
            process.terminate()
            break

if __name__ == "__main__":
    follow_logs()
