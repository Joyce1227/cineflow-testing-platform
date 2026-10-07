from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.controllers import (admin_controller, auth_controller, movie_controller, order_controller,
                             recommend_controller, review_controller, stat_controller)
from app.core.config import settings
from app.core.database import Base, SessionLocal, engine
from app.core.errors import envelope, install_error_handlers
from app.core.metrics import install_metrics
from app.core.seed import seed_demo_data
import app.entities  # noqa: F401


@asynccontextmanager
async def lifespan(_: FastAPI):
    if settings.auto_create_tables:
        Base.metadata.create_all(engine)
    if settings.seed_demo_data:
        with SessionLocal() as db:
            seed_demo_data(db)
    yield


app = FastAPI(title=settings.app_name, version="1.0.0", lifespan=lifespan,
              description="覆盖用户、电影、影院场次、锁座购票、订单、评论、推荐和统计分析的完整后端。")
install_metrics(app)
install_error_handlers(app)
for controller in (auth_controller, movie_controller, order_controller, review_controller,
                   recommend_controller, stat_controller, admin_controller):
    app.include_router(controller.router, prefix=settings.api_prefix)


@app.get("/health", tags=["系统"])
def health():
    return envelope(0, "success", {"status": "UP"})
