from time import perf_counter

from fastapi import FastAPI, Request, Response
from prometheus_client import CONTENT_TYPE_LATEST, Counter, Gauge, Histogram, REGISTRY, generate_latest

from app.core.config import settings


HTTP_REQUESTS = Counter(
    "cineflow_http_requests_total",
    "Total number of CineFlow HTTP requests.",
    ("method", "route", "status"),
)
HTTP_REQUEST_DURATION = Histogram(
    "cineflow_http_request_duration_seconds",
    "CineFlow HTTP request duration in seconds.",
    ("method", "route"),
    buckets=(0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10),
)
HTTP_REQUESTS_IN_PROGRESS = Gauge(
    "cineflow_http_requests_in_progress",
    "CineFlow HTTP requests currently being processed.",
    ("method",),
)


def _route_template(request: Request) -> str:
    route = request.scope.get("route")
    route_path = getattr(route, "path", None)
    if not route_path:
        return "unmatched"
    if request.url.path.startswith(settings.api_prefix) and not route_path.startswith(settings.api_prefix):
        return f"{settings.api_prefix}{route_path}"
    return route_path


def install_metrics(app: FastAPI) -> None:
    @app.middleware("http")
    async def record_http_metrics(request: Request, call_next):
        if request.url.path == "/metrics":
            return await call_next(request)

        method = request.method
        started_at = perf_counter()
        HTTP_REQUESTS_IN_PROGRESS.labels(method=method).inc()
        status_code = 500
        try:
            response = await call_next(request)
            status_code = response.status_code
            return response
        finally:
            route = _route_template(request)
            HTTP_REQUESTS.labels(method=method, route=route, status=str(status_code)).inc()
            HTTP_REQUEST_DURATION.labels(method=method, route=route).observe(perf_counter() - started_at)
            HTTP_REQUESTS_IN_PROGRESS.labels(method=method).dec()

    @app.get("/metrics", include_in_schema=False)
    def metrics() -> Response:
        return Response(content=generate_latest(REGISTRY), media_type=CONTENT_TYPE_LATEST)
