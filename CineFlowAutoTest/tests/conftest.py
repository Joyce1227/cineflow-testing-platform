from __future__ import annotations

import logging
import os
import sys
import tempfile
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from common.api_client import ApiClient
from common.auth import login
from common.config import Settings
from common.db import Database


def pytest_configure(config: pytest.Config) -> None:
    # Windows 上 pytest 默认复用 ``Temp/pytest-of-<用户名>``。如果这个目录曾由
    # 其他账号、管理员进程或受限沙箱创建，tmp_path 会因 ACL 不匹配而全部报
    # WinError 5。每个 pytest 进程使用独立目录，避免跨账号/进程复用旧 ACL。
    if config.option.basetemp is None:
        config.option.basetemp = str(
            Path(tempfile.gettempdir()) / f"cineflow-pytest-{os.getpid()}"
        )
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s %(message)s")


@pytest.fixture(scope="session")
def settings() -> Settings:
    return Settings.load()


@pytest.fixture
def client(settings: Settings) -> ApiClient:
    result = ApiClient(settings.base_url, settings.request_timeout, settings.verify_ssl)
    yield result
    result.session.close()


@pytest.fixture
def auth_client(client: ApiClient, settings: Settings) -> ApiClient:
    login(client, settings.test_username, settings.test_password)
    return client


@pytest.fixture(scope="session")
def database(settings: Settings):
    if not settings.database_url:
        yield None
        return
    result = Database(settings.database_url)
    yield result
    result.close()

