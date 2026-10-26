"""回忆卡片实体"""
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class MemoryCardEntity(Base):
    """回忆卡片表"""

    __tablename__ = "memory_cards"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    trip_id: Mapped[int] = mapped_column(Integer, ForeignKey("trips.id"), nullable=False, comment="关联的行程ID")
    title: Mapped[str] = mapped_column(String(200), nullable=False, comment="卡片标题")
    summary: Mapped[str] = mapped_column(Text, nullable=False, comment="卡片摘要")
    image_url: Mapped[str | None] = mapped_column(Text, nullable=True, comment="卡片图片URL")
    card_json: Mapped[str] = mapped_column(Text, nullable=False, comment="卡片数据JSON")
    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        default=datetime.utcnow,
        comment="创建时间"
    )

    def __repr__(self):
        return f"<MemoryCardEntity(id={self.id}, trip_id={self.trip_id}, title={self.title})>"
