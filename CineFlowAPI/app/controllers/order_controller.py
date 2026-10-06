from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.errors import envelope
from app.core.security import Principal, current_user
from app.schemas.requests import CreateOrderRequest, LockSeatsRequest, PaymentCallbackRequest
from app.services.ticket_service import TicketService

router = APIRouter(tags=["锁座与订单"])


@router.post("/schedules/{schedule_id}/seats/lock")
def lock_seats(schedule_id: int, request: LockSeatsRequest, user: Principal = Depends(current_user),
               db: Session = Depends(get_db)):
    return envelope(0, "success", TicketService(db).lock_seats(schedule_id, request.seat_ids, user.id))


@router.post("/orders", status_code=201)
def create_order(request: CreateOrderRequest, user: Principal = Depends(current_user), db: Session = Depends(get_db)):
    return envelope(0, "success", TicketService(db).create_order(request, user.id))


@router.get("/orders")
def list_orders(user: Principal = Depends(current_user), db: Session = Depends(get_db)):
    return envelope(0, "success", TicketService(db).list_orders(user.id))


@router.get("/orders/{order_id}")
def order_detail(order_id: int, user: Principal = Depends(current_user), db: Session = Depends(get_db)):
    return envelope(0, "success", TicketService(db).get_order(order_id, user.id))


@router.post("/orders/{order_id}/cancel")
def cancel_order(order_id: int, user: Principal = Depends(current_user), db: Session = Depends(get_db)):
    return envelope(0, "success", TicketService(db).cancel(order_id, user.id))


@router.post("/orders/{order_id}/payment-callback")
def payment_callback(order_id: int, request: PaymentCallbackRequest, user: Principal = Depends(current_user),
                     db: Session = Depends(get_db)):
    return envelope(0, "success", TicketService(db).payment(order_id, request, user.id))


@router.post("/orders/{order_id}/refund")
def refund_order(order_id: int, user: Principal = Depends(current_user), db: Session = Depends(get_db)):
    return envelope(0, "success", TicketService(db).refund(order_id, user.id))
