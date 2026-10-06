from __future__ import annotations

import json
import logging
from typing import Any

import allure
import requests

LOGGER = logging.getLogger("cineflow.api")


class ApiClient:
    def __init__(self, base_url: str, timeout: float = 10, verify_ssl: bool = False):
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.verify_ssl = verify_ssl
        self.session = requests.Session()
        # Test targets are often localhost/container services. Ignore desktop proxy
        # environment variables so these requests are never sent to an HTTP proxy.
        self.session.trust_env = False
        self.session.headers.update({"Accept": "application/json"})

    def set_token(self, token: str | None) -> None:
        if token:
            self.session.headers["Authorization"] = f"Bearer {token}"
        else:
            self.session.headers.pop("Authorization", None)

    def request(self, method: str, path: str, **kwargs: Any) -> requests.Response:
        url = path if path.startswith("http") else f"{self.base_url}/{path.lstrip('/')}"
        kwargs.setdefault("timeout", self.timeout)
        kwargs.setdefault("verify", self.verify_ssl)
        safe = {k: v for k, v in kwargs.items() if k not in {"timeout", "verify"}}
        LOGGER.info("%s %s %s", method.upper(), url, safe)
        with allure.step(f"{method.upper()} {path}"):
            allure.attach(json.dumps(safe, ensure_ascii=False, default=str, indent=2), "request",
                          allure.attachment_type.JSON)
            response = self.session.request(method, url, **kwargs)
            allure.attach(response.text, f"response-{response.status_code}", allure.attachment_type.JSON)
        LOGGER.info("status=%s body=%s", response.status_code, response.text[:1000])
        return response

    def get(self, path: str, **kwargs: Any) -> requests.Response:
        return self.request("GET", path, **kwargs)

    def post(self, path: str, **kwargs: Any) -> requests.Response:
        return self.request("POST", path, **kwargs)

    def put(self, path: str, **kwargs: Any) -> requests.Response:
        return self.request("PUT", path, **kwargs)

    def delete(self, path: str, **kwargs: Any) -> requests.Response:
        return self.request("DELETE", path, **kwargs)

    def clone(self) -> "ApiClient":
        return ApiClient(self.base_url, self.timeout, self.verify_ssl)
