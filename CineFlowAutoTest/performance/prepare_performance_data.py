from __future__ import annotations

import argparse
import csv
import json
import math
import secrets
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path

import requests


MAX_USERS = 1300


@dataclass
class Api:
    base_url: str
    timeout: float = 15

    def __post_init__(self) -> None:
        self.session = requests.Session()
        self.session.trust_env = False
        self.session.headers.update({"Accept": "application/json"})

    def request(self, method: str, path: str, *, expected: set[int], **kwargs):
        response = self.session.request(
            method, f"{self.base_url.rstrip('/')}/{path.lstrip('/')}", timeout=self.timeout, **kwargs
        )
        if response.status_code not in expected:
            raise RuntimeError(f"{method} {path} returned {response.status_code}: {response.text[:500]}")
        return response.json()

    def login(self, username: str, password: str) -> None:
        payload = self.request(
            "POST", "/api/auth/login", expected={200}, json={"username": username, "password": password}
        )
        self.session.headers["Authorization"] = f"Bearer {payload['data']['token']}"


def _write_csv(path: Path, rows: list[dict]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=["username", "password", "schedule_id", "seat_id"])
        writer.writeheader()
        writer.writerows(rows)


def prepare(base_url: str, output_dir: Path, users: int, admin_username: str, admin_password: str) -> Path:
    if users < 2:
        raise ValueError("users must be at least 2 so the contention scenario is meaningful")
    if users > MAX_USERS:
        raise ValueError(f"users cannot exceed {MAX_USERS}")

    api = Api(base_url)
    api.request("GET", "/health", expected={200})
    api.login(admin_username, admin_password)

    run_id = f"{datetime.now():%m%d%H%M%S}{secrets.token_hex(2)}"
    movie = api.request(
        "POST",
        "/api/admin/movies",
        expected={201},
        json={
            "name": f"Performance Movie {run_id}",
            "genres": "性能测试",
            "regions": "测试环境",
            "releaseYear": datetime.now().year,
            "score": 8.0,
        },
    )["data"]
    cinema = api.request(
        "POST",
        "/api/admin/cinemas",
        expected={201},
        json={"name": f"Performance Cinema {run_id}", "address": "Performance Test Only", "city": "Test"},
    )["data"]

    rows = math.ceil(users / 50)
    start = datetime.now() + timedelta(days=7)

    def create_schedule(name: str, offset_hours: int, seat_rows: int):
        begins = start + timedelta(hours=offset_hours)
        return api.request(
            "POST",
            "/api/admin/schedules",
            expected={201},
            json={
                "movieId": movie["id"],
                "cinemaId": cinema["id"],
                "hallName": name,
                "startTime": begins.isoformat(timespec="seconds"),
                "endTime": (begins + timedelta(hours=2)).isoformat(timespec="seconds"),
                "price": 45,
                "rows": seat_rows,
                "seatsPerRow": 50,
            },
        )["data"]

    booking_schedule = create_schedule("Performance Booking Hall", 0, rows)
    contention_schedule = create_schedule("Performance Contention Hall", 3, 1)
    booking_seats = api.request(
        "GET", f"/api/schedules/{booking_schedule['id']}/seats", expected={200}
    )["data"]
    contention_seats = api.request(
        "GET", f"/api/schedules/{contention_schedule['id']}/seats", expected={200}
    )["data"]
    if len(booking_seats) < users or not contention_seats:
        raise RuntimeError("API did not create enough performance-test seats")

    password = "PerfTest123"
    phone_base = secrets.randbelow(1_000_000_000 - users)
    created_users: list[dict] = []
    booking_rows: list[dict] = []
    contention_rows: list[dict] = []
    for index in range(users):
        username = f"perf_{run_id}_{index:04d}"
        phone_number = phone_base + index
        registered = api.request(
            "POST",
            "/api/auth/register",
            expected={201},
            json={
                "username": username,
                "phone": f"18{phone_number:09d}",
                "email": f"{username}@example.com",
                "password": password,
            },
        )["data"]
        created_users.append({"id": registered["id"], "username": username})
        common = {"username": username, "password": password}
        booking_rows.append(
            {**common, "schedule_id": booking_schedule["id"], "seat_id": booking_seats[index]["id"]}
        )
        contention_rows.append(
            {**common, "schedule_id": contention_schedule["id"], "seat_id": contention_seats[0]["id"]}
        )

    output_dir.mkdir(parents=True, exist_ok=True)
    _write_csv(output_dir / "booking-users.csv", booking_rows)
    _write_csv(output_dir / "contention-users.csv", contention_rows)
    metadata = {
        "runId": run_id,
        "baseUrl": base_url,
        "createdAt": datetime.now().isoformat(timespec="seconds"),
        "movieId": movie["id"],
        "cinemaId": cinema["id"],
        "scheduleIds": [booking_schedule["id"], contention_schedule["id"]],
        "userIds": [item["id"] for item in created_users],
        "usernames": [item["username"] for item in created_users],
        "users": users,
    }
    metadata_path = output_dir / "metadata.json"
    metadata_path.write_text(json.dumps(metadata, ensure_ascii=False, indent=2), encoding="utf-8")
    return metadata_path


def main() -> None:
    parser = argparse.ArgumentParser(description="Create isolated users, schedules and seats for CineFlow load tests.")
    parser.add_argument("--base-url", default="http://127.0.0.1:8000")
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--users", type=int, default=10)
    parser.add_argument("--admin-username", default="admin")
    parser.add_argument("--admin-password", default="Admin123")
    args = parser.parse_args()
    metadata_path = prepare(
        args.base_url, args.output_dir.resolve(), args.users, args.admin_username, args.admin_password
    )
    print(f"Performance data ready: {metadata_path}")


if __name__ == "__main__":
    main()
