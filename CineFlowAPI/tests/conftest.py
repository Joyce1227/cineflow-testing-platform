import os
from pathlib import Path

TEST_DB = Path(__file__).parent / "test.db"
if TEST_DB.exists():
    TEST_DB.unlink()
os.environ["DATABASE_URL"] = f"sqlite:///{TEST_DB.as_posix()}"
os.environ["SEED_DEMO_DATA"] = "true"
os.environ["AUTO_CREATE_TABLES"] = "true"

import pytest  # noqa: E402
from fastapi.testclient import TestClient  # noqa: E402
from app.main import app  # noqa: E402


@pytest.fixture(scope="session")
def client():
    with TestClient(app) as value:
        yield value


@pytest.fixture(scope="session")
def user_headers(client):
    response = client.post("/api/auth/login", json={"username": "test_user", "password": "Test1234"})
    assert response.status_code == 200
    return {"Authorization": f"Bearer {response.json()['data']['token']}"}
