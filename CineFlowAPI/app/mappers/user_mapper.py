from sqlalchemy import or_, select
from sqlalchemy.orm import Session

from app.entities.models import User


class UserMapper:
    def __init__(self, db: Session):
        self.db = db

    def by_username(self, username: str) -> User | None:
        return self.db.scalar(select(User).where(User.username == username))

    def find_duplicate(self, username: str, phone: str, email: str) -> User | None:
        return self.db.scalar(select(User).where(or_(User.username == username, User.phone == phone, User.email == email)))

    def add(self, user: User) -> User:
        self.db.add(user)
        self.db.flush()
        return user
