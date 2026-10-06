import secrets
import time
from datetime import datetime, timedelta
from decimal import Decimal

from sqlalchemy import select, update
from sqlalchemy.orm import Session

from app.core.config import settings
from app.core.errors import ApiError
from app.entities.models import OrderSeat, PaymentEvent, Seat, TicketOrder
from app.mappers.movie_mapper import MovieMapper
from app.mappers.order_mapper import OrderMapper
from app.schemas.requests import CreateOrderRequest, PaymentCallbackRequest
from app.schemas.serializers import order, seat


class TicketService:
    def __init__(self, db: Session):
        self.db = db
        self.movies = MovieMapper(db)
        self.orders = OrderMapper(db)

    def release_expired(self) -> int:
        now = datetime.now()
        expired = list(self.db.scalars(select(Seat).where(
            Seat.status == "LOCKED", Seat.lock_expires_at < now).with_for_update()).all())
        order_ids = {item.order_id for item in expired if item.order_id}
        for item in expired:
            item.status, item.lock_user_id, item.lock_expires_at, item.order_id = "AVAILABLE", None, None, None
        if order_ids:
            self.db.execute(update(TicketOrder).where(TicketOrder.id.in_(order_ids), TicketOrder.status == "PENDING_PAYMENT")
                            .values(status="EXPIRED", updated_at=now))
        return len(expired)

    def lock_seats(self, schedule_id: int, seat_ids: list[int], user_id: int) -> dict:
        self.release_expired()
        schedule = self._sellable_schedule(schedule_id)
        seats = self.movies.seats(schedule.id, sorted(seat_ids), for_update=True)
        self._validate_seats(seats, seat_ids, user_id)
        expires_at = datetime.now() + timedelta(minutes=settings.seat_lock_minutes)
        for item in seats:
            item.status, item.lock_user_id, item.lock_expires_at = "LOCKED", user_id, expires_at
        self.db.commit()
        return {"scheduleId": schedule_id, "seats": [seat(item) for item in seats], "expiresAt": expires_at.isoformat()}

    def create_order(self, request: CreateOrderRequest, user_id: int) -> dict:
        existing = self.orders.by_idempotency(user_id, request.idempotency_key)
        if existing:
            return order(existing)
        self.release_expired()
        schedule = self._sellable_schedule(request.schedule_id)
        seats = self.movies.seats(schedule.id, sorted(request.seat_ids), for_update=True)
        self._validate_seats(seats, request.seat_ids, user_id)
        ticket_order = TicketOrder(order_no=f"T{int(time.time() * 1000)}{secrets.token_hex(3).upper()}", user_id=user_id,
                                   schedule_id=schedule.id, total_amount=schedule.price * len(seats),
                                   idempotency_key=request.idempotency_key)
        self.db.add(ticket_order)
        self.db.flush()
        expires_at = datetime.now() + timedelta(minutes=settings.order_expire_minutes)
        for item in seats:
            item.status, item.lock_user_id, item.lock_expires_at, item.order_id = "LOCKED", user_id, expires_at, ticket_order.id
            self.db.add(OrderSeat(order_id=ticket_order.id, seat_id=item.id, price=schedule.price))
        self.db.commit()
        return order(self._get(ticket_order.id, user_id))

    def list_orders(self, user_id: int) -> list[dict]:
        return [order(item) for item in self.orders.list(user_id)]

    def get_order(self, order_id: int, user_id: int) -> dict:
        return order(self._get(order_id, user_id))

    def cancel(self, order_id: int, user_id: int) -> dict:
        item = self._get(order_id, user_id, True)
        if item.status != "PENDING_PAYMENT":
            raise ApiError(409, "只有待支付订单可以取消")
        item.status = "CANCELLED"
        self._release_order_seats(item)
        self.db.commit()
        return order(self._get(order_id, user_id))

    def payment(self, order_id: int, request: PaymentCallbackRequest, user_id: int) -> dict:
        item = self._get(order_id, user_id, True)
        if self.orders.payment_event(request.provider_trade_no):
            return order(item)
        if request.success and item.status != "PENDING_PAYMENT":
            raise ApiError(409, f"订单状态不允许支付: {item.status}")
        self.db.add(PaymentEvent(order_id=item.id, provider_trade_no=request.provider_trade_no, success=request.success))
        if request.success:
            item.status, item.paid_at = "PAID", datetime.now()
            for order_seat in item.seats:
                order_seat.seat.status, order_seat.seat.lock_expires_at = "SOLD", None
            item.schedule.movie.popularity += 1
        else:
            item.status = "PAYMENT_FAILED"
            self._release_order_seats(item)
        self.db.commit()
        return order(self._get(order_id, user_id))

    def refund(self, order_id: int, user_id: int) -> dict:
        item = self._get(order_id, user_id, True)
        if item.status != "PAID":
            raise ApiError(409, "只有已支付订单可以退款")
        item.status, item.refunded_at = "REFUNDED", datetime.now()
        self._release_order_seats(item)
        self.db.commit()
        return order(self._get(order_id, user_id))

    def _sellable_schedule(self, schedule_id: int):
        item = self.movies.schedule(schedule_id, for_update=True)
        if item is None:
            raise ApiError(404, "场次不存在")
        if item.status != "ON_SALE" or item.start_time <= datetime.now():
            raise ApiError(409, "场次不可售或已开场")
        return item

    def _validate_seats(self, seats: list[Seat], requested: list[int], user_id: int) -> None:
        if len(seats) != len(requested):
            raise ApiError(404, "座位不存在或不属于该场次")
        for item in seats:
            if item.status == "SOLD":
                raise ApiError(409, f"座位已售: {item.id}")
            if item.status == "LOCKED" and item.lock_user_id != user_id:
                raise ApiError(409, f"座位已被其他用户锁定: {item.id}")

    def _get(self, order_id: int, user_id: int, for_update: bool = False) -> TicketOrder:
        item = self.orders.get(order_id, user_id, for_update)
        if item is None:
            raise ApiError(404, "订单不存在")
        return item

    @staticmethod
    def _release_order_seats(item: TicketOrder) -> None:
        for order_seat in item.seats:
            target = order_seat.seat
            target.status, target.lock_user_id, target.lock_expires_at, target.order_id = "AVAILABLE", None, None, None
