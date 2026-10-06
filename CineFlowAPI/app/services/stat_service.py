from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.entities.models import (Movie, StatActorTop50, StatRegionYearAvgScore,
                                 StatYearRegionCount, StatYearTop20Movie)
from app.schemas.serializers import value


class StatService:
    def __init__(self, db: Session):
        self.db = db

    def actor_top50(self) -> list[dict]:
        rows = self.db.scalars(select(StatActorTop50).order_by(StatActorTop50.acted_movie_cnt.desc()).limit(50)).all()
        return [{"personName": r.person_name, "actedMovieCnt": r.acted_movie_cnt} for r in rows]

    def high_score_avg(self) -> dict:
        avg = self.db.scalar(select(func.avg(Movie.score)).where(Movie.score >= 8)) or 0
        return {"threshold": 8, "averageScore": value(avg)}

    def mins_summary(self) -> dict:
        total, avg, minimum, maximum = self.db.execute(select(func.sum(Movie.mins), func.avg(Movie.mins),
                                                               func.min(Movie.mins), func.max(Movie.mins))).one()
        return {"totalMins": total or 0, "averageMins": value(avg or 0), "minMins": minimum or 0, "maxMins": maximum or 0}

    def year_top20(self, year: int | None) -> list[dict]:
        query = select(StatYearTop20Movie)
        if year is not None:
            query = query.where(StatYearTop20Movie.movie_year == year)
        rows = self.db.scalars(query.order_by(StatYearTop20Movie.movie_year.desc(), StatYearTop20Movie.douban_score.desc()).limit(20 if year else 200)).all()
        return [{"movieYear": r.movie_year, "movieId": r.movie_id, "name": r.name,
                 "doubanScore": value(r.douban_score), "doubanVotes": r.douban_votes} for r in rows]

    def region_year_average(self, region: str | None, year: int | None) -> list[dict]:
        query = select(StatRegionYearAvgScore)
        if region:
            query = query.where(StatRegionYearAvgScore.region_name.contains(region))
        if year is not None:
            query = query.where(StatRegionYearAvgScore.movie_year == year)
        rows = self.db.scalars(query.order_by(StatRegionYearAvgScore.movie_year, StatRegionYearAvgScore.region_name)).all()
        return [{"regionName": r.region_name, "movieYear": r.movie_year, "regionScoreAvg": value(r.region_score_avg)} for r in rows]

    def year_region_count(self, year: int | None, region: str | None) -> list[dict]:
        query = select(StatYearRegionCount)
        if year is not None:
            query = query.where(StatYearRegionCount.movie_year == year)
        if region:
            query = query.where(StatYearRegionCount.region_name.contains(region))
        rows = self.db.scalars(query.order_by(StatYearRegionCount.movie_year, StatYearRegionCount.region_name)).all()
        return [{"movieYear": r.movie_year, "regionName": r.region_name, "regionYearCount": r.region_year_count} for r in rows]
