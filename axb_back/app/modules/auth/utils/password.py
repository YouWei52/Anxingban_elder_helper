"""密码处理工具"""
import re
from typing import Tuple

import bcrypt


def hash_password(password: str) -> str:
    """对密码进行哈希处理"""
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed.decode('utf-8')


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """验证密码"""
    try:
        return bcrypt.checkpw(
            plain_password.encode('utf-8'),
            hashed_password.encode('utf-8')
        )
    except Exception:
        return False


def validate_password_complexity(password: str) -> Tuple[bool, str]:
    """验证密码复杂度

    要求：
    - 至少8个字符
    - 至少包含一个字母
    - 至少包含一个数字
    """
    if len(password) < 8:
        return False, "密码长度至少为8个字符"

    if not re.search(r'[A-Za-z]', password):
        return False, "密码必须包含至少一个字母"

    if not re.search(r'\d', password):
        return False, "密码必须包含至少一个数字"

    return True, "密码符合要求"
