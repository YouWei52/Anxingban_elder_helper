"""老人用户实体"""
from datetime import datetime

from sqlalchemy import DateTime, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class ElderEntity(Base):
    """老人用户表"""

    __tablename__ = "elders"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(50), nullable=False, comment="姓名")
    phone: Mapped[str] = mapped_column(String(20), unique=True, nullable=False, comment="手机号")
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False, comment="密码哈希")
    health_info: Mapped[str | None] = mapped_column(Text, nullable=True, comment="健康信息")
    interests: Mapped[str | None] = mapped_column(Text, nullable=True, comment="兴趣爱好")
    wechat_webhook_url: Mapped[str] = mapped_column(Text, nullable=False, default="", comment="企业微信Webhook URL")
    avatar_url: Mapped[str | None] = mapped_column(Text, nullable=True, comment="头像URL")
    role: Mapped[str] = mapped_column(String(20), nullable=False, default="elder", comment="角色：elder/admin")
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
        return f"<ElderEntity(id={self.id}, name={self.name}, phone={self.phone}, role={self.role})>"
