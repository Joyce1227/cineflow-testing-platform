import pytest


@pytest.mark.smoke
def test_movie_filter_and_detail(client):
    response = client.get("/api/movies", params={"genre": "科幻", "region": "中国大陆"})
    assert response.status_code == 200, response.text
    movies = response.json()["data"]["list"]
    assert movies, "演示数据中应至少存在一部中国大陆科幻片"
    assert all("科幻" in item["genres"] and "中国大陆" in item["regions"] for item in movies)
    assert all(item["status"] == "AVAILABLE" for item in movies)

    scored = client.get("/api/movies", params={"minScore": 8}).json()["data"]["list"]
    assert scored
    assert all(item["score"] >= 8 for item in scored)

    detail = client.get(f"/api/movies/{movies[0]['id']}")
    assert detail.status_code == 200, detail.text
    assert detail.json()["data"]["id"] == movies[0]["id"]


@pytest.mark.regression
def test_hot_movies_have_no_off_shelf_or_duplicate_movies(client):
    response = client.get("/api/movies/hot", params={"limit": 10})
    assert response.status_code == 200, response.text
    movies = response.json()["data"]
    ids = [item["id"] for item in movies]
    assert len(ids) == len(set(ids))
    assert all(item["status"] == "AVAILABLE" for item in movies)


@pytest.mark.regression
def test_page_size_boundary(client):
    assert client.get("/api/movies", params={"pageSize": 100}).status_code == 200
    assert client.get("/api/movies", params={"pageSize": 101}).status_code == 400
