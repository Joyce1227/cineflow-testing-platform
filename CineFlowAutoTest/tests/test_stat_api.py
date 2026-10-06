import pytest


STAT_PATHS = [
    "/api/stat/actor-top50", "/api/stat/high-score-average", "/api/stat/mins-summary",
    "/api/stat/year-top20", "/api/stat/region-year-average-score", "/api/stat/year-region-count",
]


@pytest.mark.smoke
@pytest.mark.parametrize("path", STAT_PATHS)
def test_statistics_are_available(client, path):
    response = client.get(path)
    assert response.status_code == 200, response.text
    body = response.json()
    assert body["code"] == 0
    assert body["data"] is not None


@pytest.mark.regression
def test_region_year_filter(client):
    response = client.get("/api/stat/region-year-average-score", params={"region": "中国大陆", "year": 2019})
    assert response.status_code == 200, response.text
    assert all(item["regionName"] == "中国大陆" and item["movieYear"] == 2019 for item in response.json()["data"])


@pytest.mark.regression
def test_year_top20_filter(client):
    response = client.get("/api/stat/year-top20", params={"year": 2019})
    assert response.status_code == 200, response.text
    assert all(item["movieYear"] == 2019 for item in response.json()["data"])
