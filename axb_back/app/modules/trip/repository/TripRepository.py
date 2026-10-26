"""行程数据访问层"""
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.modules.trip.entity.TripEntity import TripEntity


class TripRepository:
    """Trip数据访问层"""

    def __init__(self, db: Session):
        self.db = db

    def find_by_id(self, trip_id: int) -> TripEntity | None:
        """根据ID查询行程"""
        return self.db.get(TripEntity, trip_id)

    def find_by_profile_id(self, profile_id: int, limit: int = 100) -> list[TripEntity]:
        """根据档案ID查询行程列表"""
        return list(self.db.scalars(
            select(TripEntity)
            .where(TripEntity.profile_id == profile_id)
            .order_by(TripEntity.travel_date.desc())
            .limit(limit)
        ).all())

    def find_by_elder_id(self, elder_id: int, limit: int = 100) -> list[TripEntity]:
        """根据老人ID查询行程列表"""
        return list(self.db.scalars(
            select(TripEntity)
            .where(TripEntity.elder_id == elder_id)
            .order_by(TripEntity.travel_date.desc())
            .limit(limit)
        ).all())

    def find_all(self, limit: int = 100) -> list[TripEntity]:
        """查询所有行程"""
        return list(self.db.scalars(
            select(TripEntity)
            .order_by(TripEntity.travel_date.desc())
            .limit(limit)
        ).all())

    def create(self, trip: TripEntity) -> TripEntity:
        """创建行程"""
        self.db.add(trip)
        self.db.commit()
        self.db.refresh(trip)
        return trip

    def update(self, trip: TripEntity) -> TripEntity:
        """更新行程"""
        self.db.commit()
        self.db.refresh(trip)
        return trip

    def delete(self, trip: TripEntity) -> None:
        """删除行程"""
        self.db.delete(trip)
        self.db.commit()
