from uuid import uuid4

import pytest

from common.assertions import assert_schema


def _available_show_and_seat(client):
    movies = client.get("/api/movies", params={"genre": "科幻", "region": "中国大陆"}).json()["data"]["list"]
    assert movies, "没有可用于购票测试的电影"
    for movie in movies:
        schedules = client.get(f"/api/movies/{movie['id']}/schedules").json()["data"]
        for schedule in schedules:
            seats = client.get(f"/api/schedules/{schedule['id']}/seats").json()["data"]
            available = next((seat for seat in seats if seat["status"] == "AVAILABLE"), None)
            if available:
                return movie, schedule, available
    pytest.skip("当前没有可售场次或可用座位")


@pytest.mark.smoke
@pytest.mark.serial
def test_purchase_payment_review_refund_full_flow(auth_client, database):
    movie, schedule, seat = _available_show_and_seat(auth_client)
    key = f"autotest-{uuid4().hex}"
    payload = {"scheduleId": schedule["id"], "seatIds": [seat["id"]], "idempotencyKey": key}

    created = auth_client.post("/api/orders", json=payload)
    assert created.status_code == 201, created.text
    assert_schema(created.json(), "order.schema.json")
    order = created.json()["data"]
    assert order["status"] == "PENDING_PAYMENT"

    repeated = auth_client.post("/api/orders", json=payload)
    assert repeated.status_code == 201, repeated.text
    assert repeated.json()["data"]["id"] == order["id"], "相同幂等键必须返回同一订单"

    if database:
        row = database.one("SELECT status, idempotency_key FROM ticket_order WHERE id=:id", id=order["id"])
        assert row == {"status": "PENDING_PAYMENT", "idempotency_key": key}
        assert database.scalar("SELECT status FROM schedule_seat WHERE id=:id", id=seat["id"]) == "LOCKED"

    trade_no = f"pay-{uuid4().hex}"
    paid = auth_client.post(f"/api/orders/{order['id']}/payment-callback",
                            json={"providerTradeNo": trade_no, "success": True})
    assert paid.status_code == 200, paid.text
    assert paid.json()["data"]["status"] == "PAID"
    repeated_payment = auth_client.post(f"/api/orders/{order['id']}/payment-callback",
                                        json={"providerTradeNo": trade_no, "success": True})
    assert repeated_payment.status_code == 200, repeated_payment.text

    review = auth_client.put(f"/api/movies/{movie['id']}/reviews",
                             json={"rating": 9.0, "content": "自动化测试：完整购票链路验证"})
    assert review.status_code == 200, review.text
    review_id = review.json()["data"]["id"]
    invalid_review = auth_client.put(f"/api/movies/{movie['id']}/reviews",
                                     json={"rating": 11, "content": "越界评分"})
    assert invalid_review.status_code == 422, invalid_review.text

    recommendations = auth_client.get("/api/recommendations/me", params={"limit": 10})
    assert recommendations.status_code == 200, recommendations.text
    items = recommendations.json()["data"]
    assert len({item["id"] for item in items}) == len(items)
    assert all(item["status"] == "AVAILABLE" for item in items)

    assert auth_client.delete(f"/api/reviews/{review_id}").status_code == 204
    refunded = auth_client.post(f"/api/orders/{order['id']}/refund")
    assert refunded.status_code == 200, refunded.text
    assert refunded.json()["data"]["status"] == "REFUNDED"

    if database:
        assert database.scalar("SELECT status FROM ticket_order WHERE id=:id", id=order["id"]) == "REFUNDED"
        seat_row = database.one(
            "SELECT status, lock_user_id, lock_expires_at, order_id FROM schedule_seat WHERE id=:id", id=seat["id"]
        )
        assert seat_row == {"status": "AVAILABLE", "lock_user_id": None, "lock_expires_at": None, "order_id": None}
        assert database.scalar("SELECT COUNT(*) FROM payment_event WHERE provider_trade_no=:trade", trade=trade_no) == 1


@pytest.mark.regression
def test_order_requires_authentication(client):
    response = client.post("/api/orders", json={"scheduleId": 1, "seatIds": [1], "idempotencyKey": "unauthorized"})
    assert response.status_code == 401, response.text

