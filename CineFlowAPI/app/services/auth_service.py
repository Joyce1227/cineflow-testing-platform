from sqlalchemy.orm import Session

from app.core.errors import ApiError
from app.core.config import settings
from app.core.security import Principal, create_token, hash_password, verify_password
from app.entities.models import User
from app.mappers.user_mapper import UserMapper
from app.schemas.requests import LoginRequest, RegisterRequest


class AuthService:
    def __init__(self, db: Session):
        self.db = db
        self.mapper = UserMapper(db)

    def register(self, request: RegisterRequest) -> dict:
        duplicate = self.mapper.find_duplicate(request.username, request.phone, str(request.email))
        if duplicate:
            field = "用户名" if duplicate.username == request.username else "手机号" if duplicate.phone == request.phone else "邮箱"
            raise ApiError(409, f"{field}已被注册")
        user = self.mapper.add(User(username=request.username, phone=request.phone, email=str(request.email),
                                    password_hash=hash_password(request.password)))
        self.db.commit()
        return {"id": user.id, "username": user.username}

    def login(self, request: LoginRequest) -> dict:
        user = self.mapper.by_username(request.username)
        if user is None or not verify_password(request.password, user.password_hash):
            raise ApiError(401, "用户名或密码错误")
        if user.status != "ACTIVE":
            raise ApiError(403, "用户已被禁用")
        principal = Principal(user.id, user.username, user.role)
        return {"token": create_token(principal), "tokenType": "Bearer", "expiresIn": settings.jwt_expire_minutes * 60,
                "user": {"id": user.id, "username": user.username, "role": user.role}}
