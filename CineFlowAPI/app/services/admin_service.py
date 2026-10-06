from datetime import datetime

from sqlalchemy.orm import Session

from app.core.errors import ApiError
from app.entities.models import Cinema, Movie, Schedule, Seat
from app.schemas.requests import CinemaAdminRequest, MovieAdminRequest, ScheduleAdminRequest
from app.schemas.serializers import cinema, movie, schedule


class AdminService:
    def __init__(self, db: Session):
        self.db = db

    def create_movie(self, request: MovieAdminRequest) -> dict:
        item = Movie(name=request.name, genres=request.genres, regions=request.regions,
                     release_year=request.release_year, score=request.score, status=request.status)
        self.db.add(item); self.db.commit()
        return movie(item)

    def create_cinema(self, request: CinemaAdminRequest) -> dict:
        item = Cinema(**request.model_dump())
        self.db.add(item); self.db.commit()
        return cinema(item)

    def create_schedule(self, request: ScheduleAdminRequest) -> dict:
        try:
            start, end = datetime.fromisoformat(request.start_time), datetime.fromisoformat(request.end_time)
        except ValueError as exc:
            raise ApiError(422, "startTime/endTime 必须为 ISO-8601 日期时间") from exc
        if end <= start:
            raise ApiError(400, "endTime 必须晚于 startTime")
        if self.db.get(Movie, request.movie_id) is None or self.db.get(Cinema, request.cinema_id) is None:
            raise ApiError(404, "电影或影院不存在")
        item = Schedule(movie_id=request.movie_id, cinema_id=request.cinema_id, hall_name=request.hall_name,
                        start_time=start, end_time=end, price=request.price)
        self.db.add(item); self.db.flush()
        for row in range(request.rows):
            for number in range(1, request.seats_per_row + 1):
                self.db.add(Seat(schedule_id=item.id, seat_row=chr(ord("A") + row), seat_number=number))
        self.db.commit()
        return schedule(item)
