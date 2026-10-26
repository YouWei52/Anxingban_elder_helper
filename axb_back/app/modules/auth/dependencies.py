"""认证依赖项"""
from fastapi import Depends, Header
from sqlalchemy.orm import Session
import jwt

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.entity.UserEntity import UserEntity
from app.modules.auth.entity.ElderEntity import ElderEntity
from app.modules.auth.repository.AuthRepository import UserRepository, ElderRepository
from app.modules.auth.utils.jwt_handler import decode_access_token


def get_current_user(
    authorization: str = Header(...),
    db: Session = Depends(get_db)
) -> UserEntity:
    """获取当前登录的子女用户"""
    try:
        # 提取token (格式: "Bearer <token>")
        if not authorization.startswith("Bearer "):
            raise BusinessException(ErrorCode.UNAUTHORIZED, detail="无效的认证头")

        token = authorization.replace("Bearer ", "")
        payload = decode_access_token(token)

        user_id = payload.get("sub")
        user_type = payload.get("type")

        if not user_id or user_type != "user":
            raise BusinessException(ErrorCode.UNAUTHORIZED, detail="无效的令牌")

        repo = UserRepository(db)
        user = repo.find_by_id(int(user_id))

        if not user:
            raise BusinessException(ErrorCode.UNAUTHORIZED, detail="用户不存在")

        return user

    except jwt.PyJWTError:
        raise BusinessException(ErrorCode.UNAUTHORIZED, detail="令牌无效或已过期")
    except BusinessException:
        raise
    except Exception as e:
        raise BusinessException(ErrorCode.UNAUTHORIZED, detail=f"认证失败: {str(e)}")


def get_current_elder(
    authorization: str = Header(...),
    db: Session = Depends(get_db)
) -> ElderEntity:
    """获取当前登录的老人用户"""
    try:
        # 提取token (格式: "Bearer <token>")
        if not authorization.startswith("Bearer "):
            raise BusinessException(ErrorCode.UNAUTHORIZED, detail="无效的认证头")

        token = authorization.replace("Bearer ", "")
        payload = decode_access_token(token)

        elder_id = payload.get("sub")
        user_type = payload.get("type")

        if not elder_id or user_type != "elder":
            raise BusinessException(ErrorCode.UNAUTHORIZED, detail="无效的令牌")

        repo = ElderRepository(db)
        elder = repo.find_by_id(int(elder_id))

        if not elder:
            raise BusinessException(ErrorCode.UNAUTHORIZED, detail="老人用户不存在")

        return elder

    except jwt.PyJWTError:
        raise BusinessException(ErrorCode.UNAUTHORIZED, detail="令牌无效或已过期")
    except BusinessException:
        raise
    except Exception as e:
        raise BusinessException(ErrorCode.UNAUTHORIZED, detail=f"认证失败: {str(e)}")
