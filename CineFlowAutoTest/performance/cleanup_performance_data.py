from __future__ import annotations

import argparse
import json
from pathlib import Path
from urllib.parse import urlparse

from sqlalchemy import bindparam, create_engine, text


def _ensure_safe_target(database_url: str, allow_remote: bool) -> None:
    parsed = urlparse(database_url.replace("mysql+pymysql", "mysql", 1))
    local_hosts = {"127.0.0.1", "localhost", "mysql"}
    if not allow_remote and parsed.hostname not in local_hosts:
        raise ValueError(
            f"Refusing to clean remote database host {parsed.hostname!r}. "
            "Use --allow-remote only for an authorized test environment."
        )


def cleanup(metadata_path: Path, database_url: str, allow_remote: bool = False) -> None:
    _ensure_safe_target(database_url, allow_remote)
    metadata = json.loads(metadata_path.read_text(encoding="utf-8"))
    schedule_ids = [int(value) for value in metadata["scheduleIds"]]
    user_ids = [int(value) for value in metadata["userIds"]]
    movie_id = int(metadata["movieId"])
    cinema_id = int(metadata["cinemaId"])

    engine = create_engine(database_url, pool_pre_ping=True)
    expanding = lambda sql, name: text(sql).bindparams(bindparam(name, expanding=True))
    with engine.begin() as connection:
        order_ids = list(
            connection.execute(
                expanding(
                    "SELECT id FROM ticket_order WHERE schedule_id IN :schedule_ids OR user_id IN :user_ids",
                    "schedule_ids",
                ).bindparams(bindparam("user_ids", expanding=True)),
                {"schedule_ids": schedule_ids, "user_ids": user_ids},
            ).scalars()
        )
        if order_ids:
            connection.execute(
                expanding("DELETE FROM payment_event WHERE order_id IN :order_ids", "order_ids"),
                {"order_ids": order_ids},
            )
            connection.execute(
                expanding("DELETE FROM order_seat WHERE order_id IN :order_ids", "order_ids"),
                {"order_ids": order_ids},
            )
            connection.execute(
                expanding("DELETE FROM ticket_order WHERE id IN :order_ids", "order_ids"),
                {"order_ids": order_ids},
            )
        connection.execute(
            expanding("DELETE FROM movie_review WHERE user_id IN :user_ids", "user_ids"), {"user_ids": user_ids}
        )
        connection.execute(
            expanding("DELETE FROM schedule_seat WHERE schedule_id IN :schedule_ids", "schedule_ids"),
            {"schedule_ids": schedule_ids},
        )
        connection.execute(
            expanding("DELETE FROM movie_schedule WHERE id IN :schedule_ids", "schedule_ids"),
            {"schedule_ids": schedule_ids},
        )
        connection.execute(
            expanding("DELETE FROM app_user WHERE id IN :user_ids", "user_ids"), {"user_ids": user_ids}
        )
        connection.execute(text("DELETE FROM movie WHERE id=:movie_id"), {"movie_id": movie_id})
        connection.execute(text("DELETE FROM cinema WHERE id=:cinema_id"), {"cinema_id": cinema_id})
    engine.dispose()


def main() -> None:
    parser = argparse.ArgumentParser(description="Delete only data recorded in a performance metadata file.")
    parser.add_argument("--metadata", type=Path, required=True)
    parser.add_argument("--database-url", required=True)
    parser.add_argument("--allow-remote", action="store_true")
    args = parser.parse_args()
    cleanup(args.metadata.resolve(), args.database_url, args.allow_remote)
    print(f"Performance data removed using: {args.metadata.resolve()}")


if __name__ == "__main__":
    main()
