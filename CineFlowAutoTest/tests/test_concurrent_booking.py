from concurrent.futures import ThreadPoolExecutor
from threading import Barrier
from uuid import uuid4

import pytest

from common.api_client import ApiClient
from common.auth import login


def _new_user(settings, index):
    client = ApiClient(settings.base_url, settings.request_timeout, settings.verify_ssl)
    suffix = uuid4().hex[:10]
    username = f"race{index}_{suffix}"
    phone = f"17{int(suffix[:9], 16) % 1_000_000_000:09d}"
    password = "RaceTest123"
    response = client.post("/api/auth/register", json={
        "username": username, "phone": phone, "email": f"{username}@example.com", "password": password,
    })
    assert response.status_code == 201, response.text
    login(client, username, password)
    return client


@pytest.mark.mysql
@pytest.mark.serial
def test_only_one_user_can_buy_the_same_seat(settings, client):
    if not (settings.database_url or "").startswith("mysql"):
        pytest.skip("行锁并发用例只在 MySQL 测试环境执行")
    movies = client.get("/api/movies").json()["data"]["list"]
    target = None
    for movie in movies:
        for schedule in client.get(f"/api/movies/{movie['id']}/schedules").json()["data"]:
            seats = client.get(f"/api/schedules/{schedule['id']}/seats").json()["data"]
            available = next((seat for seat in seats if seat["status"] == "AVAILABLE"), None)
            if available:
                target = schedule["id"], available["id"]
                break
        if target:
            break
    if not target:
        pytest.skip("没有可用座位")

    clients = [_new_user(settings, index) for index in range(2)]
    barrier = Barrier(2)

    def buy(index):
        barrier.wait()
        return clients[index].post("/api/orders", json={
            "scheduleId": target[0], "seatIds": [target[1]], "idempotencyKey": f"race-{uuid4().hex}"
        })

    with ThreadPoolExecutor(max_workers=2) as executor:
        responses = list(executor.map(buy, range(2)))
    assert sorted(response.status_code for response in responses) == [201, 409]
    winner = next(response for response in responses if response.status_code == 201)
    winner_id = winner.json()["data"]["userId"]
    winner_client = next(item for item in clients if item.get("/api/orders").json()["data"] and
                         item.get("/api/orders").json()["data"][0]["userId"] == winner_id)
    winner_client.post(f"/api/orders/{winner.json()['data']['id']}/cancel")
    for item in clients:
        item.session.close()

