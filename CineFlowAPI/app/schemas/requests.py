import re
from decimal import Decimal

from pydantic import BaseModel, EmailStr, Field, field_validator


class RegisterRequest(BaseModel):
    username: str = Field(min_length=3, max_length=32, pattern=r"^[A-Za-z0-9_]+$")
    phone: str = Field(pattern=r"^1[3-9]\d{9}$")
    email: EmailStr
    password: str = Field(min_length=6, max_length=72)

    @field_validator("password")
    @classmethod
    def password_strength(cls, value: str) -> str:
        if not re.search(r"[A-Za-z]", value) or not re.search(r"\d", value):
            raise ValueError("密码必须同时包含字母和数字")
        return value


class LoginRequest(BaseModel):
    username: str = Field(min_length=1, max_length=32)
    password: str = Field(min_length=1, max_length=72)


class LockSeatsRequest(BaseModel):
    seat_ids: list[int] = Field(alias="seatIds", min_length=1, max_length=8)

    @field_validator("seat_ids")
    @classmethod
    def no_duplicates(cls, value: list[int]) -> list[int]:
        if len(value) != len(set(value)):
            raise ValueError("座位 ID 不能重复")
        return value


class CreateOrderRequest(LockSeatsRequest):
    schedule_id: int = Field(alias="scheduleId", gt=0)
    idempotency_key: str = Field(alias="idempotencyKey", min_length=1, max_length=64)


class PaymentCallbackRequest(BaseModel):
    provider_trade_no: str = Field(alias="providerTradeNo", min_length=1, max_length=64)
    success: bool


class ReviewRequest(BaseModel):
    rating: Decimal = Field(ge=1, le=10, max_digits=3, decimal_places=1)
    content: str = Field(min_length=1, max_length=1000)

    @field_validator("content")
    @classmethod
    def content_not_blank(cls, value: str) -> str:
        if not value.strip():
            raise ValueError("评论内容不能为空")
        return value.strip()


class MovieAdminRequest(BaseModel):
    name: str = Field(min_length=1, max_length=255)
    genres: str = Field(default="", max_length=255)
    regions: str = Field(default="", max_length=255)
    release_year: int | None = Field(default=None, alias="releaseYear", ge=1888, le=2200)
    score: Decimal = Field(default=0, ge=0, le=10)
    status: str = Field(default="AVAILABLE", pattern=r"^(AVAILABLE|OFF_SHELF)$")


class CinemaAdminRequest(BaseModel):
    name: str = Field(min_length=1, max_length=128)
    address: str = Field(min_length=1, max_length=255)
    city: str = Field(min_length=1, max_length=64)


class ScheduleAdminRequest(BaseModel):
    movie_id: int = Field(alias="movieId", gt=0)
    cinema_id: int = Field(alias="cinemaId", gt=0)
    hall_name: str = Field(alias="hallName", min_length=1, max_length=64)
    start_time: str = Field(alias="startTime")
    end_time: str = Field(alias="endTime")
    price: Decimal = Field(gt=0, max_digits=10, decimal_places=2)
    rows: int = Field(default=5, ge=1, le=26)
    seats_per_row: int = Field(default=10, alias="seatsPerRow", ge=1, le=50)
