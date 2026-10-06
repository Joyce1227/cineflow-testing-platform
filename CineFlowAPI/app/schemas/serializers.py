from datetime import date, datetime
from decimal import Decimal

from app.entities.models import Cinema, Movie, Review, Schedule, Seat, TicketOrder


def value(v):
    if isinstance(v, Decimal):
        return float(v)
    if isinstance(v, (date, datetime)):
        return v.isoformat()
    return v


def movie(m: Movie) -> dict:
    return {"id": m.id, "name": m.name, "alias": m.alias, "actors": m.actors, "directors": m.directors,
            "cover": m.cover, "genres": m.genres, "regions": m.regions, "languages": m.languages,
            "releaseYear": m.release_year, "releaseDate": value(m.release_date), "mins": m.mins,
            "storyline": m.storyline, "score": value(m.score), "ratingCount": m.rating_count,
            "popularity": m.popularity, "status": m.status}


def cinema(c: Cinema) -> dict:
    return {"id": c.id, "name": c.name, "address": c.address, "city": c.city, "status": c.status}


def schedule(s: Schedule) -> dict:
    return {"id": s.id, "movieId": s.movie_id, "cinemaId": s.cinema_id,
            "cinemaName": s.cinema.name if s.cinema else None, "hallName": s.hall_name,
            "startTime": value(s.start_time), "endTime": value(s.end_time), "price": value(s.price), "status": s.status}


def seat(s: Seat) -> dict:
    return {"id": s.id, "scheduleId": s.schedule_id, "seatRow": s.seat_row, "seatNumber": s.seat_number,
            "seatCode": f"{s.seat_row}{s.seat_number:02d}", "status": s.status, "lockExpiresAt": value(s.lock_expires_at)}


def order(o: TicketOrder) -> dict:
    return {"id": o.id, "orderNo": o.order_no, "userId": o.user_id, "scheduleId": o.schedule_id,
            "totalAmount": value(o.total_amount), "status": o.status, "createdAt": value(o.created_at),
            "paidAt": value(o.paid_at), "refundedAt": value(o.refunded_at),
            "seats": [{**seat(item.seat), "price": value(item.price)} for item in o.seats]}


def review(r: Review) -> dict:
    return {"id": r.id, "userId": r.user_id, "username": r.user.username if r.user else None,
            "movieId": r.movie_id, "rating": value(r.rating), "content": r.content,
            "createdAt": value(r.created_at), "updatedAt": value(r.updated_at)}


def page(items: list[dict], page_num: int, page_size: int, total: int) -> dict:
    return {"list": items, "pageNum": page_num, "pageSize": page_size, "total": total,
            "totalPages": (total + page_size - 1) // page_size}
