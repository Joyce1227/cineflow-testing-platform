from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any

import yaml


ROOT = Path(__file__).resolve().parent
DEFAULT_CONFIG = ROOT / "config" / "test_env.yaml"


def _as_bool(value: Any) -> bool:
    if isinstance(value, bool):
        return value
    return str(value).strip().lower() in {"1", "true", "yes", "on"}


@dataclass(frozen=True)
class Settings:
    base_url: str
    api_url: str
    browser: str
    headless: bool
    timeout: int
    window_width: int
    window_height: int
    test_username: str
    test_password: str
    admin_username: str
    admin_password: str

    @classmethod
    def load(cls, path: Path | None = None) -> "Settings":
        config_path = path or DEFAULT_CONFIG
        raw = yaml.safe_load(config_path.read_text(encoding="utf-8")) or {}
        test_user = raw.get("test_user", {})
        admin_user = raw.get("admin_user", {})
        window = raw.get("window_size", {})
        return cls(
            base_url=os.getenv("WEB_BASE_URL", raw.get("base_url", "http://127.0.0.1:5173")).rstrip("/"),
            api_url=os.getenv("WEB_API_URL", raw.get("api_url", "http://127.0.0.1:8000/api")).rstrip("/"),
            browser=os.getenv("WEB_BROWSER", raw.get("browser", "chrome")).lower(),
            headless=_as_bool(os.getenv("WEB_HEADLESS", raw.get("headless", False))),
            timeout=int(os.getenv("WEB_TIMEOUT", raw.get("timeout", 10))),
            window_width=int(window.get("width", 1440)),
            window_height=int(window.get("height", 1000)),
            test_username=os.getenv("WEB_TEST_USER", test_user.get("username", "test_user")),
            test_password=os.getenv("WEB_TEST_PASSWORD", test_user.get("password", "Test1234")),
            admin_username=os.getenv("WEB_ADMIN_USER", admin_user.get("username", "admin")),
            admin_password=os.getenv("WEB_ADMIN_PASSWORD", admin_user.get("password", "Admin123")),
        )

