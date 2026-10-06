from datetime import datetime, timedelta

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.entities.models import (Cinema, Movie, Schedule, Seat, StatActorTop50, StatRegionYearAvgScore,
                                 StatYearRegionCount, StatYearTop20Movie, User)


def seed_demo_data(db: Session) -> None:
    if (db.scalar(select(func.count(User.id))) or 0) > 0:
        return
    admin = User(username="admin", phone="13800000000", email="admin@example.com",
                 password_hash=hash_password("Admin123"), role="ADMIN")
    user = User(username="test_user", phone="13900000000", email="user@example.com",
                password_hash=hash_password("Test1234"))
    movies = [
        Movie(name="流浪地球", genres="科幻/冒险", regions="中国大陆", release_year=2019, mins=125, score=8.2, popularity=100),
        Movie(name="星际穿越", genres="科幻/剧情", regions="美国/英国", release_year=2014, mins=169, score=9.4, popularity=200),
        Movie(name="你好，李焕英", genres="喜剧/剧情", regions="中国大陆", release_year=2021, mins=128, score=7.7, popularity=80),
        Movie(name="下架电影", genres="剧情", regions="中国大陆", release_year=2020, mins=100, score=9.9, popularity=999, status="OFF_SHELF"),
    ]
    cinema = Cinema(name="测试影城", address="测试路 1 号", city="北京")
    db.add_all([admin, user, cinema, *movies]); db.flush()
    start = datetime.now() + timedelta(days=1)
    show = Schedule(movie_id=movies[0].id, cinema_id=cinema.id, hall_name="1号厅", start_time=start,
                    end_time=start + timedelta(minutes=125), price=45)
    db.add(show); db.flush()
    db.add_all([Seat(schedule_id=show.id, seat_row=row, seat_number=number)
                for row in ("A", "B", "C") for number in range(1, 7)])
    db.add_all([
        StatActorTop50(person_name="刘德华", acted_movie_cnt=140),
        StatRegionYearAvgScore(region_name="中国大陆", movie_year=2019, region_score_avg=8.2),
        StatYearRegionCount(movie_year=2019, region_name="中国大陆", region_year_count=1),
        StatYearTop20Movie(movie_year=2019, movie_id=str(movies[0].id), name=movies[0].name,
                           douban_score=movies[0].score, douban_votes="100000"),
    ])
    db.commit()
