from __future__ import annotations

from sqlalchemy import select
from sqlalchemy.orm import Session, joinedload

from app.entities.models import OrderSeat, PaymentEvent, TicketOrder


class OrderMapper:
    def __init__(self, db: Session):
        self.db = db

    def by_idempotency(self, user_id: int, key: str) -> TicketOrder | None:
        return self.db.scalar(self._full().where(TicketOrder.user_id == user_id, TicketOrder.idempotency_key == key))

    def get(self, order_id: int, user_id: int, for_update: bool = False) -> TicketOrder | None:
        query = self._full().where(TicketOrder.id == order_id, TicketOrder.user_id == user_id)
        if for_update:
            query = query.with_for_update()
        return self.db.scalar(query)

    def list(self, user_id: int) -> list[TicketOrder]:
        return list(self.db.scalars(self._full().where(TicketOrder.user_id == user_id).order_by(TicketOrder.id.desc())).unique().all())

    def payment_event(self, trade_no: str) -> PaymentEvent | None:
        return self.db.scalar(select(PaymentEvent).where(PaymentEvent.provider_trade_no == trade_no))

    def _full(self):
        return select(TicketOrder).options(joinedload(TicketOrder.seats).joinedload(OrderSeat.seat))
