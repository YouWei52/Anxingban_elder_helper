"""行程业务逻辑层"""
from sqlalchemy.orm import Session

from app.modules.trip.dto.TripDto import TripCreateDto, TripPassResponseDto
from app.modules.trip.entity.TripEntity import TripEntity
from app.modules.trip.repository.TripRepository import TripRepository
from app.modules.profile.repository.ProfileRepository import ProfileRepository
from app.services.pass_token import generate_pass_token, generate_qr_code
from app.utils.error_codes import BusinessException, ErrorCode


class TripService:
    """行程业务逻辑"""

    @staticmethod
    def create_trip(db: Session, data: TripCreateDto) -> TripEntity:
        """创建行程"""
        # 验证档案是否存在
        profile_repo = ProfileRepository(db)
        profile = profile_repo.find_by_id(data.profile_id)
        if not profile:
            raise BusinessException(ErrorCode.NOT_FOUND, detail="档案不存在")

        # 创建行程
        trip = TripEntity(
            profile_id=data.profile_id,
            elder_id=profile.elder_id,
            destination=data.destination,
            travel_date=data.travel_date,
            notes=data.notes
        )

        repo = TripRepository(db)
        created_trip = repo.create(trip)

        # 生成通行码
        pass_token = generate_pass_token(profile.elder_id, created_trip.id)
        created_trip.pass_token = pass_token
        repo.update(created_trip)

        return created_trip

    @staticmethod
    def get_trip_by_id(db: Session, trip_id: int) -> TripEntity | None:
        """根据ID获取行程"""
        repo = TripRepository(db)
        return repo.find_by_id(trip_id)

    @staticmethod
    def list_trips_by_profile(db: Session, profile_id: int, limit: int = 100) -> list[TripEntity]:
        """根据档案ID获取行程列表"""
        repo = TripRepository(db)
        return repo.find_by_profile_id(profile_id, limit)

    @staticmethod
    def list_trips_by_elder(db: Session, elder_id: int, limit: int = 100) -> list[TripEntity]:
        """根据老人ID获取行程列表"""
        repo = TripRepository(db)
        return repo.find_by_elder_id(elder_id, limit)

    @staticmethod
    def list_all_trips(db: Session, limit: int = 100) -> list[TripEntity]:
        """获取所有行程"""
        repo = TripRepository(db)
        return repo.find_all(limit)

    @staticmethod
    def get_trip_pass(db: Session, trip: TripEntity) -> TripPassResponseDto:
        """获取行程通行码"""
        if not trip.pass_token:
            # 如果没有通行码，生成一个
            profile_repo = ProfileRepository(db)
            profile = profile_repo.find_by_id(trip.profile_id)
            if not profile:
                raise BusinessException(ErrorCode.NOT_FOUND, detail="档案不存在")

            trip.pass_token = generate_pass_token(profile.elder_id, trip.id)
            repo = TripRepository(db)
            repo.update(trip)

        qr_svg = generate_qr_code(trip.pass_token)

        return TripPassResponseDto(
            trip_id=trip.id,
            pass_token=trip.pass_token,
            pass_qr_svg=qr_svg,
            destination=trip.destination,
            travel_date=trip.travel_date
        )

    @staticmethod
    def delete_trip(db: Session, trip: TripEntity) -> None:
        """删除行程"""
        repo = TripRepository(db)
        repo.delete(trip)
