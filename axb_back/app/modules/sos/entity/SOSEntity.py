"""紧急求助实体"""
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class SOSEntity(Base):
    """紧急求助表"""

    __tablename__ = "sos_requests"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    elder_id: Mapped[int] = mapped_column(Integer, ForeignKey("elders.id"), nullable=False, comment="发起求助的老人ID")
    trip_id: Mapped[int | None] = mapped_column(Integer, ForeignKey("trips.id"), nullable=True, comment="关联的行程ID")
    location: Mapped[str | None] = mapped_column(String(500), nullable=True, comment="位置信息")
    message: Mapped[str | None] = mapped_column(Text, nullable=True, comment="求助信息")
    status: Mapped[str] = mapped_column(String(50), nullable=False, default="pending", comment="状态：pending/handled/resolved")
    created_at: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        default=datetime.utcnow,
        comment="创建时间"
    )
    resolved_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True, comment="解决时间")

    def __repr__(self):
        return f"<SOSEntity(id={self.id}, elder_id={self.elder_id}, status={self.status})>"
