"""通行码生成服务"""
import hashlib
import hmac
from datetime import datetime, timezone

import segno # type: ignore

from app.config import get_settings

settings = get_settings()

# 令牌有效期（秒）
TOKEN_EXPIRY_SECONDS = 24 * 60 * 60  # 24小时


def generate_pass_token(elder_id: int, trip_id: int) -> str:
    """生成动态通行码

    格式: ELDER-{elder_id}-{trip_id}-{unix_timestamp}-{signature}
    """
    timestamp = int(datetime.now(timezone.utc).timestamp())
    message = f"{elder_id}:{trip_id}:{timestamp}"

    # 使用HMAC生成安全的哈希
    signature = hmac.new(
        settings.token_secret.encode('utf-8'),
        message.encode('utf-8'),
        hashlib.sha256
    ).hexdigest()[:12]

    return f"ELDER-{elder_id}-{trip_id}-{timestamp}-{signature}"


def generate_qr_code(data: str) -> str:
    """生成二维码SVG"""
    try:
        qr = segno.make(data)
        return qr.svg_inline(scale=5)
    except Exception as e:
        raise ValueError(f"Failed to generate QR code: {str(e)}")


def verify_pass_token(token: str) -> dict | None:
    """验证通行码（完整验证：格式、签名、过期时间）"""
    try:
        parts = token.split('-')
        if len(parts) != 5 or parts[0] != "ELDER":
            return None

        # 验证各部分非空
        if not all(parts):
            return None

        elder_id = int(parts[1])
        trip_id = int(parts[2])
        timestamp = int(parts[3])
        received_signature = parts[4]

        # 验证签名
        message = f"{elder_id}:{trip_id}:{timestamp}"
        expected_signature = hmac.new(
            settings.token_secret.encode('utf-8'),
            message.encode('utf-8'),
            hashlib.sha256
        ).hexdigest()[:12]

        # 使用恒定时间比较防止时序攻击
        if not hmac.compare_digest(expected_signature, received_signature):
            return None

        # 验证过期时间
        current_timestamp = int(datetime.now(timezone.utc).timestamp())
        if current_timestamp - timestamp > TOKEN_EXPIRY_SECONDS:
            return None

        return {
            "elder_id": elder_id,
            "trip_id": trip_id,
            "timestamp": timestamp
        }
    except (ValueError, IndexError):
        return None
