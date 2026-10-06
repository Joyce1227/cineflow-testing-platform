from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import envelope
from app.services.stat_service import StatService

router = APIRouter(prefix="/stat", tags=["统计分析"])


@router.get("/actor-top50")
def actor_top50(db: Session = Depends(get_db)): return envelope(0, "success", StatService(db).actor_top50())


@router.get("/high-score-average")
def high_score_average(db: Session = Depends(get_db)): return envelope(0, "success", StatService(db).high_score_avg())


@router.get("/mins-summary")
def mins_summary(db: Session = Depends(get_db)): return envelope(0, "success", StatService(db).mins_summary())


@router.get("/year-top20")
def year_top20(year: int | None = None, db: Session = Depends(get_db)):
    return envelope(0, "success", StatService(db).year_top20(year))


@router.get("/region-year-average-score")
def region_year_average_score(region: str | None = None, year: int | None = None, db: Session = Depends(get_db)):
    return envelope(0, "success", StatService(db).region_year_average(region, year))


@router.get("/year-region-count")
def year_region_count(year: int | None = None, region: str | None = None, db: Session = Depends(get_db)):
    return envelope(0, "success", StatService(db).year_region_count(year, region))
