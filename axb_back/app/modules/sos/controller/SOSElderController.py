"""紧急求助控制器 - 老人用户端"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_elder
from app.modules.sos.dto.SOSDto import SOSTriggerDto, SOSResponseDto
from app.modules.sos.service.SOSService import SOSService

router = APIRouter(prefix="/api/elder/sos", tags=["老人-紧急求助"])


@router.post(
    "/trigger",
    response_model=SOSResponseDto,
    status_code=status.HTTP_201_CREATED,
    summary="触发紧急求助（老人）"
)
def trigger_sos(
    request: SOSTriggerDto,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """触发紧急求助"""
    sos = SOSService.trigger_sos(db, request, current_elder.id)
    return sos


@router.get(
    "",
    response_model=list[SOSResponseDto],
    summary="获取SOS记录列表（老人）"
)
def list_sos(
    limit: int = 100,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取SOS记录列表"""
    sos_list = SOSService.list_sos_by_elder(db, current_elder.id, limit)
    return sos_list
