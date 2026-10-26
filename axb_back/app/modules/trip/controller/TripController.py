"""行程控制器 - 子女用户端"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_user
from app.modules.trip.dto.TripDto import (
    TripCreateDto,
    TripResponseDto,
    TripPassResponseDto
)
from app.modules.trip.service.TripService import TripService

router = APIRouter(prefix="/api/user/trips", tags=["子女-行程管理"])


@router.post(
    "",
    response_model=TripResponseDto,
    status_code=status.HTTP_201_CREATED,
    summary="创建行程"
)
def create_trip(
    request: TripCreateDto,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """创建行程"""
    trip = TripService.create_trip(db, request)
    return trip


@router.get(
    "",
    response_model=list[TripResponseDto],
    summary="获取行程列表"
)
def list_trips(
    profile_id: int = None,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取行程列表"""
    if profile_id:
        trips = TripService.list_trips_by_profile(db, profile_id, limit)
    else:
        trips = TripService.list_all_trips(db, limit)
    return trips


@router.get(
    "/{trip_id}",
    response_model=TripResponseDto,
    summary="获取行程详情"
)
def get_trip(
    trip_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取行程详情"""
    trip = TripService.get_trip_by_id(db, trip_id)
    if not trip:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="行程不存在")
    return trip


@router.get(
    "/{trip_id}/pass",
    response_model=TripPassResponseDto,
    summary="获取行程通行码"
)
def get_trip_pass(
    trip_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取行程通行码和二维码"""
    trip = TripService.get_trip_by_id(db, trip_id)
    if not trip:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="行程不存在")

    return TripService.get_trip_pass(db, trip)


@router.delete(
    "/{trip_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="删除行程"
)
def delete_trip(
    trip_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """删除行程"""
    trip = TripService.get_trip_by_id(db, trip_id)
    if not trip:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="行程不存在")

    TripService.delete_trip(db, trip)
    return None
