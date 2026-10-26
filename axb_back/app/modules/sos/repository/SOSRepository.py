"""紧急求助数据访问层"""
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.modules.sos.entity.SOSEntity import SOSEntity


class SOSRepository:
    """SOS数据访问层"""

    def __init__(self, db: Session):
        self.db = db

    def find_by_id(self, sos_id: int) -> SOSEntity | None:
        """根据ID查询SOS"""
        return self.db.get(SOSEntity, sos_id)

    def find_by_elder_id(self, elder_id: int, limit: int = 100) -> list[SOSEntity]:
        """根据老人ID查询SOS列表"""
        return list(self.db.scalars(
            select(SOSEntity)
            .where(SOSEntity.elder_id == elder_id)
            .order_by(SOSEntity.created_at.desc())
            .limit(limit)
        ).all())

    def find_by_trip_id(self, trip_id: int, limit: int = 100) -> list[SOSEntity]:
        """根据行程ID查询SOS列表"""
        return list(self.db.scalars(
            select(SOSEntity)
            .where(SOSEntity.trip_id == trip_id)
            .order_by(SOSEntity.created_at.desc())
            .limit(limit)
        ).all())

    def find_all(self, limit: int = 100) -> list[SOSEntity]:
        """查询所有SOS"""
        return list(self.db.scalars(
            select(SOSEntity)
            .order_by(SOSEntity.created_at.desc())
            .limit(limit)
        ).all())

    def create(self, sos: SOSEntity) -> SOSEntity:
        """创建SOS"""
        self.db.add(sos)
        self.db.commit()
        self.db.refresh(sos)
        return sos

    def update(self, sos: SOSEntity) -> SOSEntity:
        """更新SOS"""
        self.db.commit()
        self.db.refresh(sos)
        return sos

    def delete(self, sos: SOSEntity) -> None:
        """删除SOS"""
        self.db.delete(sos)
        self.db.commit()
