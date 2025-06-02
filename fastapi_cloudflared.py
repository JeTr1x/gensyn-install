import re
import time
import threading
from fastapi import FastAPI
from fastapi.responses import RedirectResponse
import uvicorn

LOG_FILE = '/root/rl-swarm/logs/cloudflared.log'
app = FastAPI()

cloudflared_url = None
url_lock = threading.Lock()

def tail_log_and_update_url(log_file):
    global cloudflared_url
    with open(log_file, 'r') as f:
        f.seek(0, 2)  # Перейти в конец файла
        while True:
            line = f.readline()
            if not line:
                time.sleep(0.5)
                continue
            match = re.search(r'https://[a-z0-9\-]+\.trycloudflare\.com', line)
            if match:
                new_url = match.group(0)
                with url_lock:
                    if new_url != cloudflared_url:
                        cloudflared_url = new_url
                        print(f"[INFO] Обновлён URL туннеля: {cloudflared_url}")

@app.get("/{path:path}")
def redirect(path: str = ""):
    with url_lock:
        url = cloudflared_url
    if url:
        # Добавляем путь, если он есть
        redirect_url = f"{url}/{path}" if path else url
        return RedirectResponse(url=redirect_url)
    return {"error": "Cloudflared URL ещё не найден"}

if __name__ == "__main__":
    # Запускаем поток, который следит за логом и обновляет ссылку
    thread = threading.Thread(target=tail_log_and_update_url, args=(LOG_FILE,), daemon=True)
    thread.start()

    print("Запуск сервера FastAPI на 0.0.0.0:22335")
    uvicorn.run(app, host="0.0.0.0", port=22335)
