from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "CineFlowAPI - 影流电影票务与推荐系统"
    api_prefix: str = "/api"
    database_url: str = "sqlite:///./cineflow.db"
    jwt_secret: str = Field(default="development-secret-change-me-32-characters", min_length=32)
    jwt_expire_minutes: int = Field(default=120, ge=1)
    seat_lock_minutes: int = Field(default=5, ge=1)
    order_expire_minutes: int = Field(default=15, ge=1)
    auto_create_tables: bool = True
    seed_demo_data: bool = True
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")


@lru_cache
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
