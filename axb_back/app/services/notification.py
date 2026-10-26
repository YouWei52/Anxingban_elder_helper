"""通知服务"""
from typing import Optional

from app.logger import logger
from app.config import get_settings

settings = get_settings()


def send_sos_notification(elder_id: int, profile, location: Optional[str], message: Optional[str]) -> None:
    """发送SOS通知

    根据配置发送短信和企业微信通知
    """
    logger.info(f"触发SOS通知 - 老人ID: {elder_id}, 位置: {location}, 消息: {message}")

    # 短信通知（根据SMS_PROVIDER配置）
    if settings.sms_provider == "mock":
        _send_mock_sms_notification(elder_id, location, message)
    elif settings.sms_provider == "aliyun":
        _send_aliyun_sms_notification(elder_id, location, message)
    elif settings.sms_provider == "tencent":
        _send_tencent_sms_notification(elder_id, location, message)

    # 企业微信通知
    if hasattr(profile, 'elder') and hasattr(profile.elder, 'wechat_webhook_url'):
        if profile.elder.wechat_webhook_url:
            _send_wechat_notification(profile.elder.wechat_webhook_url, elder_id, location, message)


def _send_mock_sms_notification(elder_id: int, location: Optional[str], message: Optional[str]) -> None:
    """模拟短信通知（开发/测试环境）"""
    logger.info(f"[MOCK SMS] 紧急求助通知 - 老人ID: {elder_id}")
    logger.info(f"[MOCK SMS] 位置: {location or '未知'}")
    logger.info(f"[MOCK SMS] 消息: {message or '紧急求助'}")


def _send_aliyun_sms_notification(elder_id: int, location: Optional[str], message: Optional[str]) -> None:
    """阿里云短信通知"""
    # TODO: 实现阿里云短信接口
    logger.warning("阿里云短信接口未实现")


def _send_tencent_sms_notification(elder_id: int, location: Optional[str], message: Optional[str]) -> None:
    """腾讯云短信通知"""
    # TODO: 实现腾讯云短信接口
    logger.warning("腾讯云短信接口未实现")


def _send_wechat_notification(webhook_url: str, elder_id: int, location: Optional[str], message: Optional[str]) -> None:
    """企业微信通知"""
    # TODO: 实现企业微信Webhook通知
    logger.info(f"[企业微信] 发送SOS通知到: {webhook_url}")
    logger.info(f"[企业微信] 老人ID: {elder_id}, 位置: {location}, 消息: {message}")
