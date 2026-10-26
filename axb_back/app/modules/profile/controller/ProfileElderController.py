"""档案控制器 - 老人用户端"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_elder
from app.modules.profile.dto.ProfileDto import ProfileResponseDto
from app.modules.profile.service.ProfileService import ProfileService

router = APIRouter(prefix="/api/elder/profiles", tags=["老人-档案管理"])


@router.get(
    "",
    response_model=list[ProfileResponseDto],
    summary="获取档案列表（老人）"
)
def list_profiles(
    limit: int = 100,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取当前老人的档案列表（只读）"""
    profiles = ProfileService.list_profiles_by_elder(db, current_elder.id, limit)
    return profiles


@router.get(
    "/{profile_id}",
    response_model=ProfileResponseDto,
    summary="获取档案详情（老人）"
)
def get_profile(
    profile_id: int,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取档案详情（只读）"""
    profile = ProfileService.get_profile_by_id(db, profile_id)
    if not profile:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="档案不存在")
    return profile
