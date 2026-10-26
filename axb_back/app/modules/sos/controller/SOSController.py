"""紧急求助控制器 - 子女用户端"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.modules.auth.dependencies import get_current_user
from app.modules.sos.dto.SOSDto import SOSResponseDto
from app.modules.sos.service.SOSService import SOSService

router = APIRouter(prefix="/api/user/sos", tags=["子女-紧急求助"])


@router.get(
    "",
    response_model=list[SOSResponseDto],
    summary="获取SOS记录列表"
)
def list_sos(
    profile_id: int = None,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取SOS记录列表（只读）"""
    if profile_id:
        sos_list = SOSService.list_sos_by_profile(db, profile_id, limit)
    else:
        sos_list = SOSService.list_all_sos(db, limit)
    return sos_list


@router.get(
    "/profile/{profile_id}",
    response_model=list[SOSResponseDto],
    summary="获取指定档案的SOS历史"
)
def get_profile_sos_history(
    profile_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取指定档案的SOS历史"""
    sos_list = SOSService.list_sos_by_profile(db, profile_id, 100)
    return sos_list
