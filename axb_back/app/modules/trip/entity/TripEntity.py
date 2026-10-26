"""行程实体"""
from datetime import date, datetime

from sqlalchemy import Date, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class TripEntity(Base):
    """行程表"""

    __tablename__ = "trips"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    profile_id: Mapped[int] = mapped_column(Integer, ForeignKey("profiles.id"), nullable=False, comment="关联的档案ID")
    elder_id: Mapped[int] = mapped_column(Integer, ForeignKey("elders.id"), nullable=False, comment="关联的老人ID")
    destination: Mapped[str] = mapped_column(String(200), nullable=False, comment="目的地")
    travel_date: Mapped[date] = mapped_column(Date, nullable=False, comment="出行日期")
    notes: Mapped[str | None] = mapped_column(Text, nullable=True, comment="备注")
    pass_token: Mapped[str | None] = mapped_column(String(255), nullable=True, comment="动态通行码")
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
        return f"<TripEntity(id={self.id}, destination={self.destination}, travel_date={self.travel_date})>"
