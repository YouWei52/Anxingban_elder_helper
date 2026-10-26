"""档案业务逻辑层"""
from sqlalchemy.orm import Session

from app.modules.profile.dto.ProfileDto import ProfileCreateDto, ProfileUpdateDto
from app.modules.profile.entity.ProfileEntity import ProfileEntity
from app.modules.profile.repository.ProfileRepository import ProfileRepository


class ProfileService:
    """档案业务逻辑"""

    @staticmethod
    def create_profile(db: Session, data: ProfileCreateDto) -> ProfileEntity:
        """创建档案"""
        repo = ProfileRepository(db)
        profile = ProfileEntity(
            user_id=data.user_id,
            elder_id=data.elder_id,
            relationship=data.relationship or "",
            emergency_contact=data.emergency_contact,
            notes=data.notes
        )
        return repo.create(profile)

    @staticmethod
    def get_profile_by_id(db: Session, profile_id: int) -> ProfileEntity | None:
        """根据ID获取档案"""
        repo = ProfileRepository(db)
        return repo.find_by_id(profile_id)

    @staticmethod
    def list_profiles_by_user(db: Session, user_id: int, limit: int = 100) -> list[ProfileEntity]:
        """根据子女用户ID获取档案列表"""
        repo = ProfileRepository(db)
        return repo.find_by_user_id(user_id, limit)

    @staticmethod
    def list_profiles_by_elder(db: Session, elder_id: int, limit: int = 100) -> list[ProfileEntity]:
        """根据老人用户ID获取档案列表"""
        repo = ProfileRepository(db)
        return repo.find_by_elder_id(elder_id, limit)

    @staticmethod
    def list_all_profiles(db: Session, limit: int = 100) -> list[ProfileEntity]:
        """获取所有档案"""
        repo = ProfileRepository(db)
        return repo.find_all(limit)

    @staticmethod
    def update_profile(db: Session, profile: ProfileEntity, data: ProfileUpdateDto) -> ProfileEntity:
        """更新档案"""
        if data.relationship is not None:
            profile.relationship = data.relationship
        if data.emergency_contact is not None:
            profile.emergency_contact = data.emergency_contact
        if data.notes is not None:
            profile.notes = data.notes

        repo = ProfileRepository(db)
        return repo.update(profile)

    @staticmethod
    def delete_profile(db: Session, profile: ProfileEntity) -> None:
        """删除档案"""
        repo = ProfileRepository(db)
        repo.delete(profile)
