def test_auth_and_rbac(client, user_headers):
    created = client.post("/api/auth/register", json={"username": "new_user", "phone": "13700000000",
                                                           "email": "new@example.com", "password": "Pass1234"})
    assert created.status_code == 201
    assert client.post("/api/auth/register", json={"username": "new_user", "phone": "13600000000",
                                                    "email": "new2@example.com", "password": "Pass1234"}).status_code == 409
    assert client.post("/api/auth/register", json={"username": "bad", "phone": "invalid",
                                                    "email": "bad", "password": "123"}).status_code == 422
    assert client.get("/api/orders").status_code == 401
    assert client.get("/api/orders", headers={"Authorization": "Bearer forged.token.value"}).status_code == 401
    assert client.get("/api/admin/health", headers=user_headers).status_code == 403


def test_movie_filter_detail_and_paging(client):
    response = client.get("/api/movies", params={"genre": "科幻", "region": "中国大陆", "year": 2019,
                                                       "minScore": 8, "pageNum": 1, "pageSize": 5})
    assert response.status_code == 200
    data = response.json()["data"]
    assert data["list"] and len(data["list"]) <= 5
    assert all("科幻" in item["genres"] and item["releaseYear"] == 2019 for item in data["list"])
    assert client.get("/api/movies", params={"pageNum": -1}).status_code == 400
    assert client.get("/api/movies/999999").status_code == 404
    assert all(item["status"] == "AVAILABLE" for item in client.get("/api/movies/hot").json()["data"])


def test_ticket_payment_review_recommendation_flow(client, user_headers):
    movie_id = client.get("/api/movies", params={"genre": "科幻", "region": "中国大陆"}).json()["data"]["list"][0]["id"]
    schedule = client.get(f"/api/movies/{movie_id}/schedules").json()["data"][0]
    seats = client.get(f"/api/schedules/{schedule['id']}/seats").json()["data"]
    seat_id = seats[0]["id"]
    payload = {"scheduleId": schedule["id"], "seatIds": [seat_id], "idempotencyKey": "pytest-order-1"}
    created = client.post("/api/orders", json=payload, headers=user_headers)
    assert created.status_code == 201
    order = created.json()["data"]
    assert order["status"] == "PENDING_PAYMENT" and order["seats"][0]["status"] == "LOCKED"
    repeated = client.post("/api/orders", json=payload, headers=user_headers)
    assert repeated.json()["data"]["id"] == order["id"]

    second_login = client.post("/api/auth/login", json={"username": "new_user", "password": "Pass1234"}).json()["data"]["token"]
    second_headers = {"Authorization": f"Bearer {second_login}"}
    conflict = client.post("/api/orders", json={**payload, "idempotencyKey": "other-user-order"}, headers=second_headers)
    assert conflict.status_code == 409

    paid = client.post(f"/api/orders/{order['id']}/payment-callback",
                       json={"providerTradeNo": "pytest-trade-1", "success": True}, headers=user_headers)
    assert paid.status_code == 200 and paid.json()["data"]["status"] == "PAID"
    duplicate_payment = client.post(f"/api/orders/{order['id']}/payment-callback",
                                     json={"providerTradeNo": "pytest-trade-1", "success": True}, headers=user_headers)
    assert duplicate_payment.json()["data"]["status"] == "PAID"

    review = client.put(f"/api/movies/{movie_id}/reviews", json={"rating": 9.0, "content": "很好看"}, headers=user_headers)
    assert review.status_code == 200 and review.json()["data"]["rating"] == 9.0
    assert client.put(f"/api/movies/{movie_id}/reviews", json={"rating": 11, "content": "越界"}, headers=user_headers).status_code == 422
    recommendations = client.get("/api/recommendations/me", params={"limit": 3}, headers=user_headers).json()["data"]
    assert len({item["id"] for item in recommendations}) == len(recommendations)
    assert all(item["status"] == "AVAILABLE" for item in recommendations)

    refunded = client.post(f"/api/orders/{order['id']}/refund", headers=user_headers)
    assert refunded.json()["data"]["status"] == "REFUNDED"
    assert client.get(f"/api/schedules/{schedule['id']}/seats").json()["data"][0]["status"] == "AVAILABLE"


def test_statistics(client):
    paths = ["actor-top50", "year-top20", "region-year-average-score", "year-region-count"]
    for path in paths:
        response = client.get(f"/api/stat/{path}")
        assert response.status_code == 200 and response.json()["data"]
    assert client.get("/api/stat/high-score-average").json()["data"]["averageScore"] >= 0
    assert client.get("/api/stat/mins-summary").json()["data"]["totalMins"] >= 0
