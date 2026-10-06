from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import envelope
from app.core.security import Principal, current_user
from app.services.review_service import ReviewService

router = APIRouter(prefix="/recommendations", tags=["推荐"])


@router.get("/hot")
def hot_recommendations(limit: int = 10, db: Session = Depends(get_db)):
    return envelope(0, "success", ReviewService(db).recommend(None, limit))


@router.get("/me")
def my_recommendations(limit: int = 10, user: Principal = Depends(current_user), db: Session = Depends(get_db)):
    return envelope(0, "success", ReviewService(db).recommend(user.id, limit))
