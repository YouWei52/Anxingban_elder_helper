"""行程控制器 - 老人用户端"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_elder
from app.modules.trip.dto.TripDto import TripResponseDto, TripPassResponseDto
from app.modules.trip.service.TripService import TripService

router = APIRouter(prefix="/api/elder/trips", tags=["老人-行程管理"])


@router.get(
    "",
    response_model=list[TripResponseDto],
    summary="获取行程列表（老人）"
)
def list_trips(
    profile_id: int = None,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取行程列表（只读）"""
    if profile_id:
        trips = TripService.list_trips_by_profile(db, profile_id, limit)
    else:
        trips = TripService.list_trips_by_elder(db, current_elder.id, limit)
    return trips


@router.get(
    "/{trip_id}",
    response_model=TripResponseDto,
    summary="获取行程详情（老人）"
)
def get_trip(
    trip_id: int,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取行程详情（只读）"""
    trip = TripService.get_trip_by_id(db, trip_id)
    if not trip:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="行程不存在")
    return trip


@router.get(
    "/{trip_id}/pass",
    response_model=TripPassResponseDto,
    summary="获取行程通行码（老人）"
)
def get_trip_pass(
    trip_id: int,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取行程通行码和二维码（只读）"""
    trip = TripService.get_trip_by_id(db, trip_id)
    if not trip:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="行程不存在")

    return TripService.get_trip_pass(db, trip)
