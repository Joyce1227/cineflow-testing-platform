import base64
import hashlib
import hmac
import json
import os
import time
from dataclasses import dataclass

from fastapi import Depends
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.config import settings
from app.core.errors import ApiError


bearer = HTTPBearer(auto_error=False)


@dataclass(frozen=True)
class Principal:
    id: int
    username: str
    role: str


def hash_password(password: str) -> str:
    salt = os.urandom(16)
    digest = hashlib.scrypt(password.encode(), salt=salt, n=2**14, r=8, p=1)
    return f"scrypt${base64.urlsafe_b64encode(salt).decode()}${base64.urlsafe_b64encode(digest).decode()}"


def verify_password(password: str, encoded: str) -> bool:
    try:
        algorithm, salt, expected = encoded.split("$", 2)
        if algorithm != "scrypt":
            return False
        actual = hashlib.scrypt(password.encode(), salt=base64.urlsafe_b64decode(salt), n=2**14, r=8, p=1)
        return hmac.compare_digest(actual, base64.urlsafe_b64decode(expected))
    except (ValueError, TypeError):
        return False


def _b64(value: bytes) -> str:
    return base64.urlsafe_b64encode(value).rstrip(b"=").decode()


def _decode(value: str) -> bytes:
    return base64.urlsafe_b64decode(value + "=" * (-len(value) % 4))


def create_token(principal: Principal) -> str:
    now = int(time.time())
    header = _b64(json.dumps({"alg": "HS256", "typ": "JWT"}, separators=(",", ":")).encode())
    payload = _b64(json.dumps({"sub": principal.id, "username": principal.username, "role": principal.role,
                               "iat": now, "exp": now + settings.jwt_expire_minutes * 60}, separators=(",", ":")).encode())
    signature = hmac.new(settings.jwt_secret.encode(), f"{header}.{payload}".encode(), hashlib.sha256).digest()
    return f"{header}.{payload}.{_b64(signature)}"


def parse_token(token: str) -> Principal:
    try:
        header, payload, signature = token.split(".")
        expected = hmac.new(settings.jwt_secret.encode(), f"{header}.{payload}".encode(), hashlib.sha256).digest()
        if not hmac.compare_digest(expected, _decode(signature)):
            raise ApiError(401, "token 伪造或签名无效")
        data = json.loads(_decode(payload))
        if int(data["exp"]) <= int(time.time()):
            raise ApiError(401, "token 已过期")
        return Principal(id=int(data["sub"]), username=data["username"], role=data["role"])
    except ApiError:
        raise
    except Exception as exc:
        raise ApiError(401, "token 格式无效") from exc


def current_user(credentials: HTTPAuthorizationCredentials | None = Depends(bearer)) -> Principal:
    if credentials is None:
        raise ApiError(401, "缺少 token")
    return parse_token(credentials.credentials)


def admin_user(user: Principal = Depends(current_user)) -> Principal:
    if user.role != "ADMIN":
        raise ApiError(403, "普通用户无权访问管理员接口")
    return user
