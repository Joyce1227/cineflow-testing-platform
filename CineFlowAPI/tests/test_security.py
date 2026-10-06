import base64
import json
import time
from uuid import uuid4

import pytest

from app.core import security


def _login(client, username: str, password: str) -> tuple[dict[str, str], str]:
    response = client.post("/api/auth/login", json={"username": username, "password": password})
    assert response.status_code == 200, response.text
    token = response.json()["data"]["token"]
    return {"Authorization": f"Bearer {token}"}, token


def _new_user(client, prefix: str = "security") -> dict[str, str]:
    suffix = uuid4().hex[:10]
    username = f"{prefix}_{suffix}"
    password = "Security123"
    response = client.post(
        "/api/auth/register",
        json={
            "username": username,
            "phone": f"18{int(suffix[:9], 16) % 1_000_000_000:09d}",
            "email": f"{username}@example.com",
            "password": password,
        },
    )
    assert response.status_code == 201, response.text
    return _login(client, username, password)[0]


def _available_ticket(client) -> tuple[int, int, int]:
    movies = client.get("/api/movies").json()["data"]["list"]
    for movie in movies:
        schedules = client.get(f"/api/movies/{movie['id']}/schedules").json()["data"]
        for schedule in schedules:
            seats = client.get(f"/api/schedules/{schedule['id']}/seats").json()["data"]
            available = next((seat for seat in seats if seat["status"] == "AVAILABLE"), None)
            if available:
                return movie["id"], schedule["id"], available["id"]
    pytest.fail("没有可用于安全测试的可售座位")


def _tamper_role(token: str) -> str:
    header, payload, signature = token.split(".")
    decoded = json.loads(base64.urlsafe_b64decode(payload + "=" * (-len(payload) % 4)))
    decoded["role"] = "ADMIN"
    forged_payload = base64.urlsafe_b64encode(
        json.dumps(decoded, separators=(",", ":")).encode()
    ).rstrip(b"=").decode()
    return f"{header}.{forged_payload}.{signature}"


@pytest.mark.security
def test_rejects_malformed_forged_and_expired_tokens(client, monkeypatch):
    _, token = _login(client, "test_user", "Test1234")
    protected = "/api/orders"

    assert client.get(protected, headers={"Authorization": "Bearer malformed"}).status_code == 401
    assert client.get(
        "/api/admin/health", headers={"Authorization": f"Bearer {_tamper_role(token)}"}
    ).status_code == 401

    current_time = time.time()
    monkeypatch.setattr(security.time, "time", lambda: current_time + 24 * 60 * 60)
    assert client.get(protected, headers={"Authorization": f"Bearer {token}"}).status_code == 401


@pytest.mark.security
@pytest.mark.parametrize(
    ("method", "path", "payload"),
    [
        ("get", "/api/admin/health", None),
        ("post", "/api/admin/movies", {"name": "越权创建的电影"}),
        ("post", "/api/admin/cinemas", {"name": "越权影院", "address": "测试路", "city": "北京"}),
        (
            "post",
            "/api/admin/schedules",
            {
                "movieId": 1,
                "cinemaId": 1,
                "hallName": "越权厅",
                "startTime": "2030-01-01T10:00:00",
                "endTime": "2030-01-01T12:00:00",
                "price": 40,
            },
        ),
    ],
)
def test_regular_user_is_blocked_from_every_admin_endpoint(client, user_headers, method, path, payload):
    kwargs = {"headers": user_headers}
    if payload is not None:
        kwargs["json"] = payload
    response = getattr(client, method)(path, **kwargs)
    assert response.status_code == 403, response.text
    assert response.json()["code"] == 403


@pytest.mark.security
def test_admin_role_is_accepted(client):
    admin_headers, _ = _login(client, "admin", "Admin123")
    response = client.get("/api/admin/health", headers=admin_headers)
    assert response.status_code == 200, response.text
    assert response.json()["data"]["status"] == "UP"


@pytest.mark.security
def test_order_idor_is_blocked_for_read_and_state_changes(client, user_headers):
    _, schedule_id, seat_id = _available_ticket(client)
    intruder_headers = _new_user(client, "idor")
    created = client.post(
        "/api/orders",
        json={"scheduleId": schedule_id, "seatIds": [seat_id], "idempotencyKey": f"idor-{uuid4().hex}"},
        headers=user_headers,
    )
    assert created.status_code == 201, created.text
    order_id = created.json()["data"]["id"]

    attempts = [
        client.get(f"/api/orders/{order_id}", headers=intruder_headers),
        client.post(f"/api/orders/{order_id}/cancel", headers=intruder_headers),
        client.post(
            f"/api/orders/{order_id}/payment-callback",
            json={"providerTradeNo": f"attacker-{uuid4().hex}", "success": True},
            headers=intruder_headers,
        ),
        client.post(f"/api/orders/{order_id}/refund", headers=intruder_headers),
    ]
    assert [response.status_code for response in attempts] == [404, 404, 404, 404]
    assert all(item["id"] != order_id for item in client.get("/api/orders", headers=intruder_headers).json()["data"])

    owner_order = client.get(f"/api/orders/{order_id}", headers=user_headers)
    assert owner_order.status_code == 200
    assert owner_order.json()["data"]["status"] == "PENDING_PAYMENT"
    assert client.post(f"/api/orders/{order_id}/cancel", headers=user_headers).status_code == 200


@pytest.mark.security
def test_review_idor_is_blocked(client, user_headers):
    movie_id, schedule_id, seat_id = _available_ticket(client)
    intruder_headers = _new_user(client, "review_idor")
    created = client.post(
        "/api/orders",
        json={"scheduleId": schedule_id, "seatIds": [seat_id], "idempotencyKey": f"review-{uuid4().hex}"},
        headers=user_headers,
    )
    assert created.status_code == 201, created.text
    order_id = created.json()["data"]["id"]
    paid = client.post(
        f"/api/orders/{order_id}/payment-callback",
        json={"providerTradeNo": f"security-pay-{uuid4().hex}", "success": True},
        headers=user_headers,
    )
    assert paid.status_code == 200, paid.text
    review = client.put(
        f"/api/movies/{movie_id}/reviews",
        json={"rating": 8.8, "content": "对象级权限安全测试"},
        headers=user_headers,
    )
    assert review.status_code == 200, review.text
    review_id = review.json()["data"]["id"]

    forbidden = client.delete(f"/api/reviews/{review_id}", headers=intruder_headers)
    assert forbidden.status_code == 403, forbidden.text
    assert forbidden.json()["code"] == 403

    assert client.delete(f"/api/reviews/{review_id}", headers=user_headers).status_code == 204
    assert client.post(f"/api/orders/{order_id}/refund", headers=user_headers).status_code == 200
