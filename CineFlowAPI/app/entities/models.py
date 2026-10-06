from datetime import date, datetime
from decimal import Decimal

from sqlalchemy import BigInteger, Boolean, Date, DateTime, ForeignKey, Index, Integer, Numeric, String, Text, UniqueConstraint
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base

ID_TYPE = BigInteger().with_variant(Integer, "sqlite")


class TimestampMixin:
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, nullable=False)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, onupdate=datetime.now, nullable=False)


class User(Base, TimestampMixin):
    __tablename__ = "app_user"
    __table_args__ = (UniqueConstraint("username"), UniqueConstraint("phone"), UniqueConstraint("email"))
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    username: Mapped[str] = mapped_column(String(32), nullable=False)
    phone: Mapped[str] = mapped_column(String(11), nullable=False)
    email: Mapped[str] = mapped_column(String(128), nullable=False)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    role: Mapped[str] = mapped_column(String(16), default="USER", nullable=False)
    status: Mapped[str] = mapped_column(String(16), default="ACTIVE", nullable=False)


class Movie(Base, TimestampMixin):
    __tablename__ = "movie"
    __table_args__ = (Index("idx_movie_filter", "status", "release_year", "score"),)
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    alias: Mapped[str | None] = mapped_column(String(255))
    actors: Mapped[str | None] = mapped_column(Text)
    directors: Mapped[str | None] = mapped_column(Text)
    cover: Mapped[str | None] = mapped_column(String(500))
    genres: Mapped[str] = mapped_column(String(255), default="", nullable=False)
    regions: Mapped[str] = mapped_column(String(255), default="", nullable=False)
    languages: Mapped[str | None] = mapped_column(String(255))
    release_year: Mapped[int | None]
    release_date: Mapped[date | None] = mapped_column(Date)
    mins: Mapped[int | None]
    storyline: Mapped[str | None] = mapped_column(Text)
    score: Mapped[Decimal] = mapped_column(Numeric(4, 2), default=0, nullable=False)
    rating_count: Mapped[int] = mapped_column(default=0, nullable=False)
    popularity: Mapped[int] = mapped_column(default=0, nullable=False)
    status: Mapped[str] = mapped_column(String(16), default="AVAILABLE", nullable=False)


class Cinema(Base, TimestampMixin):
    __tablename__ = "cinema"
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(128), nullable=False)
    address: Mapped[str] = mapped_column(String(255), nullable=False)
    city: Mapped[str] = mapped_column(String(64), nullable=False)
    status: Mapped[str] = mapped_column(String(16), default="OPEN", nullable=False)


class Schedule(Base, TimestampMixin):
    __tablename__ = "movie_schedule"
    __table_args__ = (Index("idx_schedule_movie_time", "movie_id", "start_time"),)
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    movie_id: Mapped[int] = mapped_column(ForeignKey("movie.id"), nullable=False)
    cinema_id: Mapped[int] = mapped_column(ForeignKey("cinema.id"), nullable=False)
    hall_name: Mapped[str] = mapped_column(String(64), nullable=False)
    start_time: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    end_time: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    price: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    status: Mapped[str] = mapped_column(String(16), default="ON_SALE", nullable=False)
    movie: Mapped[Movie] = relationship()
    cinema: Mapped[Cinema] = relationship()


class Seat(Base, TimestampMixin):
    __tablename__ = "schedule_seat"
    __table_args__ = (UniqueConstraint("schedule_id", "seat_row", "seat_number"), Index("idx_seat_lock", "status", "lock_expires_at"))
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    schedule_id: Mapped[int] = mapped_column(ForeignKey("movie_schedule.id"), nullable=False)
    seat_row: Mapped[str] = mapped_column(String(8), nullable=False)
    seat_number: Mapped[int] = mapped_column(nullable=False)
    status: Mapped[str] = mapped_column(String(16), default="AVAILABLE", nullable=False)
    lock_user_id: Mapped[int | None] = mapped_column(ForeignKey("app_user.id"))
    lock_expires_at: Mapped[datetime | None] = mapped_column(DateTime)
    order_id: Mapped[int | None] = mapped_column(BigInteger)


class TicketOrder(Base, TimestampMixin):
    __tablename__ = "ticket_order"
    __table_args__ = (UniqueConstraint("order_no"), UniqueConstraint("user_id", "idempotency_key"), Index("idx_order_user", "user_id", "status"))
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    order_no: Mapped[str] = mapped_column(String(40), nullable=False)
    user_id: Mapped[int] = mapped_column(ForeignKey("app_user.id"), nullable=False)
    schedule_id: Mapped[int] = mapped_column(ForeignKey("movie_schedule.id"), nullable=False)
    total_amount: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    status: Mapped[str] = mapped_column(String(24), default="PENDING_PAYMENT", nullable=False)
    idempotency_key: Mapped[str] = mapped_column(String(64), nullable=False)
    paid_at: Mapped[datetime | None] = mapped_column(DateTime)
    refunded_at: Mapped[datetime | None] = mapped_column(DateTime)
    schedule: Mapped[Schedule] = relationship()
    seats: Mapped[list["OrderSeat"]] = relationship(back_populates="order", cascade="all, delete-orphan")


class OrderSeat(Base):
    __tablename__ = "order_seat"
    __table_args__ = (UniqueConstraint("order_id", "seat_id"),)
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    order_id: Mapped[int] = mapped_column(ForeignKey("ticket_order.id"), nullable=False)
    seat_id: Mapped[int] = mapped_column(ForeignKey("schedule_seat.id"), nullable=False)
    price: Mapped[Decimal] = mapped_column(Numeric(10, 2), nullable=False)
    order: Mapped[TicketOrder] = relationship(back_populates="seats")
    seat: Mapped[Seat] = relationship()


class PaymentEvent(Base):
    __tablename__ = "payment_event"
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    order_id: Mapped[int] = mapped_column(ForeignKey("ticket_order.id"), nullable=False)
    provider_trade_no: Mapped[str] = mapped_column(String(64), unique=True, nullable=False)
    success: Mapped[bool] = mapped_column(Boolean, nullable=False)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.now, nullable=False)


class Review(Base, TimestampMixin):
    __tablename__ = "movie_review"
    __table_args__ = (UniqueConstraint("user_id", "movie_id"), Index("idx_review_movie", "movie_id", "created_at"))
    id: Mapped[int] = mapped_column(ID_TYPE, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("app_user.id"), nullable=False)
    movie_id: Mapped[int] = mapped_column(ForeignKey("movie.id"), nullable=False)
    rating: Mapped[Decimal] = mapped_column(Numeric(3, 1), nullable=False)
    content: Mapped[str] = mapped_column(String(1000), nullable=False)
    user: Mapped[User] = relationship()
    movie: Mapped[Movie] = relationship()


# 与原 Java 工程中的统计表保持同名，已有数据可直接迁移到 cineflow_db。
class StatActorTop50(Base):
    __tablename__ = "stat_actor_top50"
    person_name: Mapped[str] = mapped_column(String(255), primary_key=True)
    acted_movie_cnt: Mapped[int] = mapped_column(BigInteger, nullable=False)


class StatYearTop20Movie(Base):
    __tablename__ = "stat_year_top20_movie"
    movie_year: Mapped[int] = mapped_column(primary_key=True)
    movie_id: Mapped[str] = mapped_column(String(32), primary_key=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    douban_score: Mapped[Decimal] = mapped_column(Numeric(4, 2), nullable=False)
    douban_votes: Mapped[str | None] = mapped_column(String(32))


class StatRegionYearAvgScore(Base):
    __tablename__ = "stat_region_year_avg_score"
    region_name: Mapped[str] = mapped_column(String(100), primary_key=True)
    movie_year: Mapped[int] = mapped_column(primary_key=True)
    region_score_avg: Mapped[Decimal] = mapped_column(Numeric(5, 2), nullable=False)


class StatYearRegionCount(Base):
    __tablename__ = "stat_year_region_count"
    movie_year: Mapped[int] = mapped_column(primary_key=True)
    region_name: Mapped[str] = mapped_column(String(100), primary_key=True)
    region_year_count: Mapped[int] = mapped_column(BigInteger, nullable=False)
