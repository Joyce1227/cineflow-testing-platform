from fastapi import APIRouter, Depends, Query, Response
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import envelope
from app.core.security import Principal, current_user
from app.schemas.requests import ReviewRequest
from app.services.review_service import ReviewService

router = APIRouter(tags=["评分评论"])


@router.put("/movies/{movie_id}/reviews")
def save_review(movie_id: int, request: ReviewRequest, user: Principal = Depends(current_user),
                db: Session = Depends(get_db)):
    return envelope(0, "success", ReviewService(db).save(movie_id, request, user.id))


@router.get("/movies/{movie_id}/reviews")
def list_reviews(movie_id: int, page_num: int = Query(default=1, alias="pageNum"),
                 page_size: int = Query(default=10, alias="pageSize"), db: Session = Depends(get_db)):
    return envelope(0, "success", ReviewService(db).list(movie_id, page_num, page_size))


@router.delete("/reviews/{review_id}", status_code=204)
def delete_review(review_id: int, user: Principal = Depends(current_user), db: Session = Depends(get_db)):
    ReviewService(db).delete(review_id, user)
    return Response(status_code=204)
