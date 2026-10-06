from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

import yaml
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parents[1]


def _bool(value: str | bool) -> bool:
    return str(value).strip().lower() in {"1", "true", "yes", "on"}


@dataclass(frozen=True)
class Settings:
    base_url: str
    database_url: str | None
    request_timeout: float
    verify_ssl: bool
    test_username: str
    test_password: str
    admin_username: str
    admin_password: str

    @classmethod
    def load(cls) -> "Settings":
        load_dotenv(ROOT / ".env")
        path = Path(os.getenv("TEST_CONFIG", ROOT / "config" / "test_env.yaml"))
        raw = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
        test_user = raw.get("test_user", {})
        admin_user = raw.get("admin_user", {})
        return cls(
            base_url=os.getenv("BASE_URL", raw.get("base_url", "http://127.0.0.1:8000")).rstrip("/"),
            database_url=os.getenv("DATABASE_URL", raw.get("database_url")) or None,
            request_timeout=float(os.getenv("REQUEST_TIMEOUT", raw.get("request_timeout", 10))),
            verify_ssl=_bool(os.getenv("VERIFY_SSL", raw.get("verify_ssl", False))),
            test_username=os.getenv("TEST_USERNAME", test_user.get("username", "test_user")),
            test_password=os.getenv("TEST_PASSWORD", test_user.get("password", "Test1234")),
            admin_username=os.getenv("ADMIN_USERNAME", admin_user.get("username", "admin")),
            admin_password=os.getenv("ADMIN_PASSWORD", admin_user.get("password", "Admin123")),
        )

