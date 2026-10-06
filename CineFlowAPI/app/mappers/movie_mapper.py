from __future__ import annotations

from decimal import Decimal

from sqlalchemy import func, or_, select
from sqlalchemy.orm import Session, joinedload

from app.entities.models import Cinema, Movie, Review, Schedule, Seat


class MovieMapper:
    def __init__(self, db: Session):
        self.db = db

    def list(self, genre: str | None, region: str | None, year: int | None, min_score: Decimal | None,
             page_num: int, page_size: int) -> tuple[list[Movie], int]:
        conditions = [Movie.status == "AVAILABLE"]
        if genre:
            conditions.append(Movie.genres.contains(genre.strip()))
        if region:
            conditions.append(Movie.regions.contains(region.strip()))
        if year is not None:
            conditions.append(Movie.release_year == year)
        if min_score is not None:
            conditions.append(Movie.score >= min_score)
        total = self.db.scalar(select(func.count(Movie.id)).where(*conditions)) or 0
        rows = self.db.scalars(select(Movie).where(*conditions).order_by(Movie.id)
                               .offset((page_num - 1) * page_size).limit(page_size)).all()
        return list(rows), total

    def get(self, movie_id: int, include_off_shelf: bool = False) -> Movie | None:
        query = select(Movie).where(Movie.id == movie_id)
        if not include_off_shelf:
            query = query.where(Movie.status == "AVAILABLE")
        return self.db.scalar(query)

    def hot(self, limit: int, excluded_ids: set[int] | None = None) -> list[Movie]:
        query = select(Movie).where(Movie.status == "AVAILABLE")
        if excluded_ids:
            query = query.where(Movie.id.not_in(excluded_ids))
        return list(self.db.scalars(query.order_by(Movie.popularity.desc(), Movie.score.desc(), Movie.id).limit(limit)).all())

    def recommended_by_genres(self, genres: list[str], user_id: int, limit: int) -> list[Movie]:
        preferences = [Movie.genres.contains(g) for g in genres]
        reviewed = select(Review.movie_id).where(Review.user_id == user_id)
        query = select(Movie).where(Movie.status == "AVAILABLE", or_(*preferences), Movie.id.not_in(reviewed))
        return list(self.db.scalars(query.order_by(Movie.score.desc(), Movie.popularity.desc(), Movie.id).limit(limit)).all())

    def cinemas(self) -> list[Cinema]:
        return list(self.db.scalars(select(Cinema).where(Cinema.status == "OPEN").order_by(Cinema.id)).all())

    def schedules(self, movie_id: int, now) -> list[Schedule]:
        return list(self.db.scalars(select(Schedule).options(joinedload(Schedule.cinema)).where(
            Schedule.movie_id == movie_id, Schedule.status == "ON_SALE", Schedule.start_time > now
        ).order_by(Schedule.start_time)).all())

    def schedule(self, schedule_id: int, for_update: bool = False) -> Schedule | None:
        query = select(Schedule).options(joinedload(Schedule.cinema)).where(Schedule.id == schedule_id)
        if for_update:
            query = query.with_for_update()
        return self.db.scalar(query)

    def seats(self, schedule_id: int, ids: list[int] | None = None, for_update: bool = False) -> list[Seat]:
        query = select(Seat).where(Seat.schedule_id == schedule_id)
        if ids is not None:
            query = query.where(Seat.id.in_(ids))
        query = query.order_by(Seat.id)
        if for_update:
            query = query.with_for_update()
        return list(self.db.scalars(query).all())
