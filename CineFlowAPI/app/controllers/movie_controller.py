from decimal import Decimal

from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import envelope
from app.services.movie_service import MovieService

router = APIRouter(tags=["电影、影院与场次"])


@router.get("/movies")
def movies(genre: str | None = None, region: str | None = None, year: int | None = None,
           min_score: Decimal | None = Query(default=None, alias="minScore", ge=0, le=10),
           page_num: int = Query(default=1, alias="pageNum"), page_size: int = Query(default=10, alias="pageSize"),
           db: Session = Depends(get_db)):
    return envelope(0, "success", MovieService(db).list_movies(genre, region, year, min_score, page_num, page_size))


@router.get("/movies/hot")
def hot_movies(limit: int = 10, db: Session = Depends(get_db)):
    return envelope(0, "success", MovieService(db).hot(limit))


@router.get("/movies/{movie_id}")
def movie_detail(movie_id: int, db: Session = Depends(get_db)):
    return envelope(0, "success", MovieService(db).get_movie(movie_id))


@router.get("/movies/{movie_id}/schedules")
def movie_schedules(movie_id: int, db: Session = Depends(get_db)):
    return envelope(0, "success", MovieService(db).schedules(movie_id))


@router.get("/cinemas")
def cinemas(db: Session = Depends(get_db)):
    return envelope(0, "success", MovieService(db).cinemas())


@router.get("/schedules/{schedule_id}/seats")
def schedule_seats(schedule_id: int, db: Session = Depends(get_db)):
    return envelope(0, "success", MovieService(db).seats(schedule_id))
