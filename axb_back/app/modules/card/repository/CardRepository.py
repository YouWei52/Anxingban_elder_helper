from sqlalchemy import select
from sqlalchemy.orm import Session

from app.modules.card.entity.MemoryCardEntity import MemoryCardEntity


class CardRepository:
    """Card 数据访问层"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def find_by_id(self, card_id: int) -> MemoryCardEntity | None:
        """根据ID查询回忆卡片"""
        return self.db.get(MemoryCardEntity, card_id)
    
    def find_by_trip(self, trip_id: int) -> list[MemoryCardEntity]:
        """根据行程ID查询回忆卡片列表"""
        return list(self.db.scalars(
            select(MemoryCardEntity)
            .where(MemoryCardEntity.trip_id == trip_id)
            .order_by(MemoryCardEntity.id.desc())
        ).all())
    
    def find_by_profile(self, profile_id: int) -> list[MemoryCardEntity]:
        """根据档案ID查询回忆卡片列表（通过关联查询）"""
        from app.modules.trip.entity.TripEntity import TripEntity
        stmt = select(MemoryCardEntity).join(TripEntity).where(TripEntity.profile_id == profile_id).order_by(MemoryCardEntity.id.desc())
        return list(self.db.scalars(stmt).all())
    
    def find_all(self, limit: int = 100) -> list[MemoryCardEntity]:
        """查询所有回忆卡片"""
        return list(self.db.scalars(
            select(MemoryCardEntity)
            .order_by(MemoryCardEntity.id.desc())
            .limit(limit)
        ).all())
    
    def create(self, card: MemoryCardEntity) -> MemoryCardEntity:
        """创建回忆卡片"""
        self.db.add(card)
        self.db.commit()
        self.db.refresh(card)
        return card
    
    def delete(self, card: MemoryCardEntity) -> None:
        """删除回忆卡片"""
        self.db.delete(card)
        self.db.commit()
