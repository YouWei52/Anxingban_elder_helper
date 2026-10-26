"""档案控制器 - 子女用户端"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from fastapi_permissions import Allow

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_user
from app.modules.auth.permissions import get_active_principals
from app.modules.profile.dto.ProfileDto import (
    ProfileCreateDto,
    ProfileUpdateDto,
    ProfileResponseDto
)
from app.modules.profile.service.ProfileService import ProfileService
from app.modules.profile.entity.ProfileEntity import ProfileEntity

router = APIRouter(prefix="/api/user/profiles", tags=["子女-档案管理"])


def get_profile_or_404(profile_id: int, db: Session = Depends(get_db)) -> ProfileEntity:
    """获取档案或返回404（用作依赖项）"""
    profile = ProfileService.get_profile_by_id(db, profile_id)
    if not profile:
        raise HTTPException(status_code=404, detail="档案不存在")
    return profile


def check_permission(resource: ProfileEntity, user, required_permission: str) -> bool:
    """
    检查用户是否对资源有指定权限

    Args:
        resource: 资源对象（必须实现 __acl__() 方法）
        user: 当前用户
        required_permission: 需要的权限（如 "view", "edit", "delete"）

    Returns:
        bool: 是否有权限
    """
    principals = get_active_principals(user)
    acl = resource.__acl__()

    for (effect, principal, permission) in acl:
        if principal in principals and permission == required_permission:
            if effect == Allow:
                return True

    return False


def require_view_permission(
    profile: ProfileEntity = Depends(get_profile_or_404),
    current_user = Depends(get_current_user)
) -> ProfileEntity:
    """检查查看权限的依赖函数"""
    if not check_permission(profile, current_user, "view"):
        raise HTTPException(status_code=403, detail="无权限查看此档案")
    return profile


def require_edit_permission(
    profile: ProfileEntity = Depends(get_profile_or_404),
    current_user = Depends(get_current_user)
) -> ProfileEntity:
    """检查编辑权限的依赖函数"""
    if not check_permission(profile, current_user, "edit"):
        raise HTTPException(status_code=403, detail="无权限编辑此档案")
    return profile


def require_delete_permission(
    profile: ProfileEntity = Depends(get_profile_or_404),
    current_user = Depends(get_current_user)
) -> ProfileEntity:
    """检查删除权限的依赖函数"""
    if not check_permission(profile, current_user, "delete"):
        raise HTTPException(status_code=403, detail="无权限删除此档案")
    return profile


@router.post(
    "",
    response_model=ProfileResponseDto,
    status_code=status.HTTP_201_CREATED,
    summary="创建档案关联"
)
def create_profile(
    request: ProfileCreateDto,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """创建档案关联"""
    profile = ProfileService.create_profile(db, request)
    return profile


@router.get(
    "",
    response_model=list[ProfileResponseDto],
    summary="获取档案列表"
)
def list_profiles(
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取当前用户的档案列表"""
    profiles = ProfileService.list_profiles_by_user(db, current_user.id, limit)
    return profiles


@router.get(
    "/{profile_id}",
    response_model=ProfileResponseDto,
    summary="获取档案详情"
)
def get_profile(
    profile: ProfileEntity = Depends(require_view_permission)
):
    """
    获取档案详情

    权限要求：
    - 档案创建者可查看
    - 关联的老人可查看
    - 管理员可查看
    """
    return profile


@router.patch(
    "/{profile_id}",
    response_model=ProfileResponseDto,
    summary="更新档案信息（PATCH）"
)
@router.put(
    "/{profile_id}",
    response_model=ProfileResponseDto,
    summary="更新档案信息（PUT）"
)
def update_profile(
    request: ProfileUpdateDto,
    db: Session = Depends(get_db),
    profile: ProfileEntity = Depends(require_edit_permission)
):
    """
    更新档案信息

    权限要求：
    - 档案创建者可编辑
    - 管理员可编辑
    """
    updated_profile = ProfileService.update_profile(db, profile, request)
    return updated_profile


@router.delete(
    "/{profile_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="删除档案"
)
def delete_profile(
    db: Session = Depends(get_db),
    profile: ProfileEntity = Depends(require_delete_permission)
):
    """
    删除档案

    权限要求：
    - 档案创建者可删除
    - 管理员可删除
    """
    ProfileService.delete_profile(db, profile)
    return None
