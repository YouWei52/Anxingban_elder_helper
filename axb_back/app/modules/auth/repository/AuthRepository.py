from sqlalchemy import select
from sqlalchemy.orm import Session

from app.modules.auth.entity.UserEntity import UserEntity
from app.modules.auth.entity.ElderEntity import ElderEntity


class UserRepository:
    """User 数据访问层"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def find_by_id(self, user_id: int) -> UserEntity | None:
        """根据ID查询用户"""
        return self.db.get(UserEntity, user_id)
    
    def find_by_phone(self, phone: str) -> UserEntity | None:
        """根据手机号查询用户"""
        return self.db.scalar(select(UserEntity).where(UserEntity.phone == phone))
    
    def create(self, user: UserEntity) -> UserEntity:
        """创建用户"""
        self.db.add(user)
        self.db.commit()
        self.db.refresh(user)
        return user
    
    def update(self, user: UserEntity) -> UserEntity:
        """更新用户"""
        self.db.commit()
        self.db.refresh(user)
        return user


class ElderRepository:
    """Elder 数据访问层"""
    
    def __init__(self, db: Session):
        self.db = db
    
    def find_by_id(self, elder_id: int) -> ElderEntity | None:
        """根据ID查询老人"""
        return self.db.get(ElderEntity, elder_id)
    
    def find_by_phone(self, phone: str) -> ElderEntity | None:
        """根据手机号查询老人"""
        return self.db.scalar(select(ElderEntity).where(ElderEntity.phone == phone))
    
    def create(self, elder: ElderEntity) -> ElderEntity:
        """创建老人"""
        self.db.add(elder)
        self.db.commit()
        self.db.refresh(elder)
        return elder
    
    def update(self, elder: ElderEntity) -> ElderEntity:
        """更新老人"""
        self.db.commit()
        self.db.refresh(elder)
        return elder
