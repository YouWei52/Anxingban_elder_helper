"""JWT处理工具"""
from datetime import datetime, timedelta
from typing import Any, Dict

import jwt

from app.config import get_settings

settings = get_settings()


def create_access_token(data: Dict[str, Any]) -> str:
    """创建访问令牌

    Args:
        data: 要编码的数据，通常包含 {"sub": user_id, "type": "user" or "elder"}

    Returns:
        JWT令牌字符串
    """
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=settings.access_token_expire_minutes)
    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(
        to_encode,
        settings.secret_key,
        algorithm=settings.algorithm
    )
    return encoded_jwt


def decode_access_token(token: str) -> Dict[str, Any]:
    """解码访问令牌

    Args:
        token: JWT令牌字符串

    Returns:
        解码后的数据字典

    Raises:
        jwt.PyJWTError: 令牌无效或过期
    """
    payload = jwt.decode(
        token,
        settings.secret_key,
        algorithms=[settings.algorithm]
    )
    return payload
