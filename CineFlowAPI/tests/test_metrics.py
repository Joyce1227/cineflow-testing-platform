def test_metrics_endpoint_exposes_http_metrics(client):
    client.get("/health")

    response = client.get("/metrics")

    assert response.status_code == 200
    assert response.headers["content-type"].startswith("text/plain")
    assert 'cineflow_http_requests_total{method="GET",route="/health",status="200"}' in response.text
    assert 'cineflow_http_request_duration_seconds_count{method="GET",route="/health"}' in response.text


def test_metrics_use_route_templates_instead_of_resource_ids(client):
    client.get("/api/movies/999999")
    metrics = client.get("/metrics").text

    assert 'route="/api/movies/{movie_id}"' in metrics
    assert 'route="/api/movies/999999"' not in metrics
