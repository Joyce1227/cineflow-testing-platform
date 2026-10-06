from __future__ import annotations

from sqlalchemy.orm import Session

from app.core.errors import ApiError
from app.core.security import Principal
from app.entities.models import Review
from app.mappers.movie_mapper import MovieMapper
from app.mappers.review_mapper import ReviewMapper
from app.schemas.requests import ReviewRequest
from app.schemas.serializers import movie, page, review
from app.services.movie_service import MovieService


class ReviewService:
    def __init__(self, db: Session):
        self.db = db
        self.movies = MovieMapper(db)
        self.reviews = ReviewMapper(db)

    def save(self, movie_id: int, request: ReviewRequest, user_id: int) -> dict:
        target = self.movies.get(movie_id)
        if target is None:
            raise ApiError(404, "电影不存在")
        if not self.reviews.has_paid_ticket(user_id, movie_id):
            raise ApiError(403, "仅已购票用户可评分评论")
        item = self.reviews.by_user_movie(user_id, movie_id)
        if item is None:
            item = Review(user_id=user_id, movie_id=movie_id, rating=request.rating, content=request.content)
            self.db.add(item)
        else:
            item.rating, item.content = request.rating, request.content
        self.db.flush()
        self.reviews.refresh_score(target)
        self.db.commit()
        return review(self.reviews.get(item.id))

    def list(self, movie_id: int, page_num: int, page_size: int) -> dict:
        MovieService.check_page(page_num, page_size)
        if self.movies.get(movie_id) is None:
            raise ApiError(404, "电影不存在")
        rows, total = self.reviews.list(movie_id, page_num, page_size)
        return page([review(item) for item in rows], page_num, page_size, total)

    def delete(self, review_id: int, user: Principal) -> None:
        item = self.reviews.get(review_id)
        if item is None:
            raise ApiError(404, "评论不存在")
        if item.user_id != user.id and user.role != "ADMIN":
            raise ApiError(403, "只能删除自己的评论")
        target = item.movie
        self.db.delete(item)
        self.db.flush()
        self.reviews.refresh_score(target)
        self.db.commit()

    def recommend(self, user_id: int | None, limit: int) -> list[dict]:
        if not 1 <= limit <= 50:
            raise ApiError(400, "limit 必须在 1 到 50 之间")
        if user_id is None:
            return [movie(item) for item in self.movies.hot(limit)]
        genres = self.reviews.favorite_genres(user_id)
        selected = self.movies.recommended_by_genres(genres, user_id, limit) if genres else []
        ids = {item.id for item in selected}
        selected += self.movies.hot(limit - len(selected), ids)
        return [movie(item) for item in selected]
