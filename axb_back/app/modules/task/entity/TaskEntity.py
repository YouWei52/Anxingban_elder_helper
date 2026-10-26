"""任务实体"""
from datetime import datetime

from sqlalchemy import Boolean, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class TaskEntity(Base):
    """代际任务表"""

    __tablename__ = "tasks"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    trip_id: Mapped[int] = mapped_column(Integer, ForeignKey("trips.id"), nullable=False, comment="关联的行程ID")
    user_id: Mapped[int] = mapped_column(Integer, ForeignKey("users.id"), nullable=False, comment="创建任务的子女用户ID")
    title: Mapped[str] = mapped_column(String(200), nullable=False, comment="任务标题")
    description: Mapped[str | None] = mapped_column(Text, nullable=True, comment="任务描述")
    user_completed: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False, comment="子女是否已完成")
    elder_completed: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False, comment="老人是否已完成")
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
        return f"<TaskEntity(id={self.id}, title={self.title}, trip_id={self.trip_id})>"
