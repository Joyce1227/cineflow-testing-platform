import pytest


def _assert_recommendations(response):
    assert response.status_code == 200, response.text
    movies = response.json()["data"]
    ids = [item["id"] for item in movies]
    assert len(ids) == len(set(ids))
    assert all(item["status"] == "AVAILABLE" for item in movies)


@pytest.mark.smoke
def test_hot_recommendations(client):
    _assert_recommendations(client.get("/api/recommendations/hot", params={"limit": 3}))


@pytest.mark.regression
def test_personal_recommendations(auth_client):
    _assert_recommendations(auth_client.get("/api/recommendations/me", params={"limit": 3}))


def test_recommendation_limit_boundary(client):
    response = client.get("/api/recommendations/hot", params={"limit": 51})
    assert response.status_code == 400, response.text

