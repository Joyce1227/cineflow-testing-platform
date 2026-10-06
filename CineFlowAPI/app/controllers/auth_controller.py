from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import envelope
from app.schemas.requests import LoginRequest, RegisterRequest
from app.services.auth_service import AuthService

router = APIRouter(prefix="/auth", tags=["用户与权限"])


@router.post("/register", status_code=201)
def register(request: RegisterRequest, db: Session = Depends(get_db)):
    return envelope(0, "success", AuthService(db).register(request))


@router.post("/login")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    return envelope(0, "success", AuthService(db).login(request))
