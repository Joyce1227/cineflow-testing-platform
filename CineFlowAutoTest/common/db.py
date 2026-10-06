from __future__ import annotations

from typing import Any

from sqlalchemy import create_engine, text
from sqlalchemy.engine import Engine


class Database:
    def __init__(self, url: str):
        self.engine: Engine = create_engine(url, pool_pre_ping=True)

    def one(self, sql: str, **params: Any) -> dict[str, Any] | None:
        with self.engine.connect() as connection:
            row = connection.execute(text(sql), params).mappings().first()
            return dict(row) if row else None

    def all(self, sql: str, **params: Any) -> list[dict[str, Any]]:
        with self.engine.connect() as connection:
            return [dict(row) for row in connection.execute(text(sql), params).mappings()]

    def scalar(self, sql: str, **params: Any) -> Any:
        with self.engine.connect() as connection:
            return connection.execute(text(sql), params).scalar()

    def close(self) -> None:
        self.engine.dispose()

