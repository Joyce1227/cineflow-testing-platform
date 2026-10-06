from uuid import uuid4

import pytest


@pytest.mark.smoke
def test_register_login_and_duplicate_username(client):
    suffix = uuid4().hex[:10]
    payload = {
        "username": f"auto_{suffix}",
        "phone": f"18{int(suffix[:9], 16) % 1_000_000_000:09d}",
        "email": f"auto_{suffix}@example.com",
        "password": "AutoTest123",
    }
    created = client.post("/api/auth/register", json=payload)
    assert created.status_code == 201, created.text
    assert created.json()["data"]["username"] == payload["username"]

    logged_in = client.post("/api/auth/login", json={"username": payload["username"], "password": payload["password"]})
    assert logged_in.status_code == 200, logged_in.text
    assert logged_in.json()["data"]["token"]

    duplicate = client.post("/api/auth/register", json=payload)
    assert duplicate.status_code == 409, duplicate.text
    assert duplicate.json()["code"] == 409


@pytest.mark.regression
def test_protected_endpoint_rejects_missing_and_invalid_token(client):
    missing = client.get("/api/orders")
    assert missing.status_code == 401, missing.text

    client.set_token("not-a-valid-jwt")
    invalid = client.get("/api/orders")
    assert invalid.status_code == 401, invalid.text


@pytest.mark.regression
def test_normal_user_cannot_access_admin(auth_client):
    response = auth_client.get("/api/admin/health")
    assert response.status_code == 403, response.text
    assert response.json()["code"] == 403
