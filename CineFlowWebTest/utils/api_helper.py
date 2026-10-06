from __future__ import annotations

import pytest
import requests


class ApiHelper:
    def __init__(self, api_url: str, timeout: int = 5):
        self.api_url = api_url.rstrip("/")
        self.timeout = timeout
        self.session = requests.Session()
        # Local test services must not be routed through a corporate/system proxy.
        self.session.trust_env = False

    def assert_services_ready(self, web_url: str) -> None:
        failures: list[str] = []
        for name, url in (
            ("CineFlowWeb", web_url.rstrip("/") + "/"),
            ("CineFlowAPI", f"{self.api_url}/movies?pageNum=1&pageSize=1"),
        ):
            try:
                response = self.session.get(url, timeout=self.timeout)
                if response.status_code >= 500:
                    failures.append(f"{name} returned HTTP {response.status_code}: {url}")
            except requests.RequestException as exc:
                failures.append(f"{name} is unavailable at {url}: {exc}")
        if failures:
            pytest.fail("\n".join(failures), pytrace=False)

    def login_result(self, username: str, password: str) -> dict:
        response = self.session.post(
            f"{self.api_url}/auth/login",
            json={"username": username, "password": password},
            timeout=self.timeout,
        )
        response.raise_for_status()
        return response.json()["data"]

    def login(self, username: str, password: str) -> str:
        return self.login_result(username, password)["token"]

    def cleanup_order(self, username: str, password: str, order_id: int) -> None:
        """Best-effort cleanup for a stateful UI test."""
        token = self.login(username, password)
        headers = {"Authorization": f"Bearer {token}"}
        detail = self.session.get(
            f"{self.api_url}/orders/{order_id}", headers=headers, timeout=self.timeout
        )
        if detail.status_code != 200:
            return
        status = detail.json()["data"]["status"]
        action = {"PENDING_PAYMENT": "cancel", "PAID": "refund"}.get(status)
        if action:
            self.session.post(
                f"{self.api_url}/orders/{order_id}/{action}",
                headers=headers,
                timeout=self.timeout,
            )
