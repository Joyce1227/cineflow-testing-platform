from datetime import datetime
from decimal import Decimal

from sqlalchemy.orm import Session

from app.core.errors import ApiError
from app.mappers.movie_mapper import MovieMapper
from app.schemas.serializers import cinema, movie, page, schedule, seat


class MovieService:
    def __init__(self, db: Session):
        self.mapper = MovieMapper(db)

    @staticmethod
    def check_page(page_num: int, page_size: int) -> None:
        if page_num < 1:
            raise ApiError(400, "pageNum 必须大于等于 1")
        if not 1 <= page_size <= 100:
            raise ApiError(400, "pageSize 必须在 1 到 100 之间")

    def list_movies(self, genre: str | None, region: str | None, year: int | None, min_score: Decimal | None,
                    page_num: int, page_size: int) -> dict:
        self.check_page(page_num, page_size)
        rows, total = self.mapper.list(genre, region, year, min_score, page_num, page_size)
        return page([movie(item) for item in rows], page_num, page_size, total)

    def get_movie(self, movie_id: int) -> dict:
        item = self.mapper.get(movie_id)
        if item is None:
            raise ApiError(404, "电影不存在")
        return movie(item)

    def hot(self, limit: int) -> list[dict]:
        if not 1 <= limit <= 100:
            raise ApiError(400, "limit 必须在 1 到 100 之间")
        return [movie(item) for item in self.mapper.hot(limit)]

    def cinemas(self) -> list[dict]:
        return [cinema(item) for item in self.mapper.cinemas()]

    def schedules(self, movie_id: int) -> list[dict]:
        self.get_movie(movie_id)
        return [schedule(item) for item in self.mapper.schedules(movie_id, datetime.now())]

    def seats(self, schedule_id: int) -> list[dict]:
        item = self.mapper.schedule(schedule_id)
        if item is None:
            raise ApiError(404, "场次不存在")
        return [seat(item) for item in self.mapper.seats(schedule_id)]
