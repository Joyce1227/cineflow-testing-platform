from __future__ import annotations

from sqlalchemy import func, select
from sqlalchemy.orm import Session, joinedload

from app.entities.models import Movie, Review, Schedule, TicketOrder


class ReviewMapper:
    def __init__(self, db: Session):
        self.db = db

    def has_paid_ticket(self, user_id: int, movie_id: int) -> bool:
        count = self.db.scalar(select(func.count(TicketOrder.id)).join(Schedule).where(
            TicketOrder.user_id == user_id, Schedule.movie_id == movie_id, TicketOrder.status == "PAID"))
        return bool(count)

    def by_user_movie(self, user_id: int, movie_id: int) -> Review | None:
        return self.db.scalar(select(Review).where(Review.user_id == user_id, Review.movie_id == movie_id))

    def get(self, review_id: int) -> Review | None:
        return self.db.scalar(select(Review).options(joinedload(Review.user)).where(Review.id == review_id))

    def list(self, movie_id: int, page_num: int, page_size: int) -> tuple[list[Review], int]:
        total = self.db.scalar(select(func.count(Review.id)).where(Review.movie_id == movie_id)) or 0
        rows = self.db.scalars(select(Review).options(joinedload(Review.user)).where(Review.movie_id == movie_id)
                               .order_by(Review.id.desc()).offset((page_num - 1) * page_size).limit(page_size)).all()
        return list(rows), total

    def favorite_genres(self, user_id: int) -> list[str]:
        values = self.db.scalars(select(Movie.genres).join(Review).where(Review.user_id == user_id, Review.rating >= 7)
                                 .order_by(Review.rating.desc()).limit(20)).all()
        return list(dict.fromkeys(g.strip() for value in values for g in value.replace("|", "/").replace(",", "/").split("/") if g.strip()))[:3]

    def refresh_score(self, movie: Movie) -> None:
        avg, count = self.db.execute(select(func.avg(Review.rating), func.count(Review.id)).where(Review.movie_id == movie.id)).one()
        movie.score = avg or 0
        movie.rating_count = count
