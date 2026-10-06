import os
import sys
import time

import requests

url = os.getenv("BASE_URL", "http://127.0.0.1:8000").rstrip("/") + "/health"
deadline = time.time() + float(os.getenv("WAIT_TIMEOUT", "60"))
while time.time() < deadline:
    try:
        if requests.get(url, timeout=2).status_code == 200:
            print(f"API ready: {url}")
            raise SystemExit(0)
    except requests.RequestException:
        pass
    time.sleep(1)
print(f"API did not become ready: {url}", file=sys.stderr)
raise SystemExit(1)

