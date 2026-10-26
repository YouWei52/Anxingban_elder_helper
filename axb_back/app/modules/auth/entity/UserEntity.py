"""子女用户实体"""
from datetime import datetime

from sqlalchemy import DateTime, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class UserEntity(Base):
    """子女用户表"""

    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    nickname: Mapped[str] = mapped_column(String(50), nullable=False, comment="昵称")
    phone: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, comment="手机号")
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False, comment="密码哈希")
    avatar_url: Mapped[str | None] = mapped_column(Text, nullable=True, comment="头像URL")
    role: Mapped[str] = mapped_column(String(20), nullable=False, default="user", comment="角色：user/admin")
    last_login_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True, comment="最后登录时间")
    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        default=datetime.utcnow,
        comment="创建时间"
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
        comment="更新时间"
    )

    def __repr__(self):
        return f"<UserEntity(id={self.id}, nickname={self.nickname}, phone={self.phone}, role={self.role})>"
