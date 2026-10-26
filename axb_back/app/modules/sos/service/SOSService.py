"""紧急求助业务逻辑层"""
from sqlalchemy.orm import Session

from app.modules.sos.dto.SOSDto import SOSTriggerDto
from app.modules.sos.entity.SOSEntity import SOSEntity
from app.modules.sos.repository.SOSRepository import SOSRepository
from app.modules.profile.repository.ProfileRepository import ProfileRepository
from app.services.notification import send_sos_notification
from app.utils.error_codes import BusinessException, ErrorCode
from app.logger import logger


class SOSService:
    """紧急求助业务逻辑"""

    @staticmethod
    def trigger_sos(db: Session, data: SOSTriggerDto, elder_id: int) -> SOSEntity:
        """触发紧急求助"""
        # 验证档案
        profile_repo = ProfileRepository(db)
        profile = profile_repo.find_by_id(data.profile_id)
        if not profile:
            raise BusinessException(ErrorCode.NOT_FOUND, detail="档案不存在")

        # 构建位置信息
        location = None
        if data.latitude and data.longitude:
            location = f"{data.latitude},{data.longitude}"

        # 创建SOS记录
        sos = SOSEntity(
            elder_id=elder_id,
            trip_id=data.trip_id,
            location=location,
            message=data.message or "紧急求助",
            status="pending"
        )

        repo = SOSRepository(db)
        created_sos = repo.create(sos)

        # 发送通知（异步处理，不阻塞响应）
        try:
            send_sos_notification(elder_id, profile, location, data.message)
        except Exception as e:
            logger.error(f"发送SOS通知失败: {e}", exc_info=True)
            # 通知失败不影响SOS记录创建

        return created_sos

    @staticmethod
    def get_sos_by_id(db: Session, sos_id: int) -> SOSEntity | None:
        """根据ID获取SOS记录"""
        repo = SOSRepository(db)
        return repo.find_by_id(sos_id)

    @staticmethod
    def list_sos_by_elder(db: Session, elder_id: int, limit: int = 100) -> list[SOSEntity]:
        """根据老人ID获取SOS记录"""
        repo = SOSRepository(db)
        return repo.find_by_elder_id(elder_id, limit)

    @staticmethod
    def list_sos_by_profile(db: Session, profile_id: int, limit: int = 100) -> list[SOSEntity]:
        """根据档案ID获取SOS记录"""
        # 需要通过档案获取老人ID
        profile_repo = ProfileRepository(db)
        profile = profile_repo.find_by_id(profile_id)
        if not profile:
            return []

        repo = SOSRepository(db)
        return repo.find_by_elder_id(profile.elder_id, limit)

    @staticmethod
    def list_all_sos(db: Session, limit: int = 100) -> list[SOSEntity]:
        """获取所有SOS记录"""
        repo = SOSRepository(db)
        return repo.find_all(limit)

    @staticmethod
    def resolve_sos(db: Session, sos: SOSEntity) -> SOSEntity:
        """解决SOS"""
        sos.status = "resolved"
        repo = SOSRepository(db)
        return repo.update(sos)
