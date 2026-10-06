from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import envelope
from app.core.security import Principal, admin_user
from app.schemas.requests import CinemaAdminRequest, MovieAdminRequest, ScheduleAdminRequest
from app.services.admin_service import AdminService

router = APIRouter(prefix="/admin", tags=["管理员"])


@router.get("/health")
def admin_health(_: Principal = Depends(admin_user)): return envelope(0, "success", {"status": "UP"})


@router.post("/movies", status_code=201)
def create_movie(request: MovieAdminRequest, _: Principal = Depends(admin_user), db: Session = Depends(get_db)):
    return envelope(0, "success", AdminService(db).create_movie(request))


@router.post("/cinemas", status_code=201)
def create_cinema(request: CinemaAdminRequest, _: Principal = Depends(admin_user), db: Session = Depends(get_db)):
    return envelope(0, "success", AdminService(db).create_cinema(request))


@router.post("/schedules", status_code=201)
def create_schedule(request: ScheduleAdminRequest, _: Principal = Depends(admin_user), db: Session = Depends(get_db)):
    return envelope(0, "success", AdminService(db).create_schedule(request))
