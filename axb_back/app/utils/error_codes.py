"""统一错误码定义"""
from enum import Enum
from typing import Any, Optional

from fastapi import HTTPException, status


class ErrorCode(str, Enum):
    """错误码枚举"""

    # 成功
    SUCCESS = "SUCCESS"

    # 客户端错误 4xx
    BAD_REQUEST = "BAD_REQUEST"
    UNAUTHORIZED = "UNAUTHORIZED"
    FORBIDDEN = "FORBIDDEN"
    NOT_FOUND = "NOT_FOUND"
    CONFLICT = "CONFLICT"
    VALIDATION_ERROR = "VALIDATION_ERROR"

    # 服务器错误 5xx
    INTERNAL_ERROR = "INTERNAL_ERROR"
    DATABASE_ERROR = "DATABASE_ERROR"
    EXTERNAL_SERVICE_ERROR = "EXTERNAL_SERVICE_ERROR"

    # 业务错误
    INVALID_CREDENTIALS = "INVALID_CREDENTIALS"
    TOKEN_EXPIRED = "TOKEN_EXPIRED"
    INSUFFICIENT_PERMISSION = "INSUFFICIENT_PERMISSION"


# 错误码到HTTP状态码的映射
ERROR_CODE_TO_HTTP_STATUS = {
    ErrorCode.SUCCESS: status.HTTP_200_OK,
    ErrorCode.BAD_REQUEST: status.HTTP_400_BAD_REQUEST,
    ErrorCode.UNAUTHORIZED: status.HTTP_401_UNAUTHORIZED,
    ErrorCode.FORBIDDEN: status.HTTP_403_FORBIDDEN,
    ErrorCode.NOT_FOUND: status.HTTP_404_NOT_FOUND,
    ErrorCode.CONFLICT: status.HTTP_409_CONFLICT,
    ErrorCode.VALIDATION_ERROR: status.HTTP_422_UNPROCESSABLE_ENTITY,
    ErrorCode.INTERNAL_ERROR: status.HTTP_500_INTERNAL_SERVER_ERROR,
    ErrorCode.DATABASE_ERROR: status.HTTP_500_INTERNAL_SERVER_ERROR,
    ErrorCode.EXTERNAL_SERVICE_ERROR: status.HTTP_502_BAD_GATEWAY,
    ErrorCode.INVALID_CREDENTIALS: status.HTTP_401_UNAUTHORIZED,
    ErrorCode.TOKEN_EXPIRED: status.HTTP_401_UNAUTHORIZED,
    ErrorCode.INSUFFICIENT_PERMISSION: status.HTTP_403_FORBIDDEN,
}


class BusinessException(HTTPException):
    """业务异常"""

    def __init__(
        self,
        error_code: ErrorCode,
        detail: Optional[str] = None,
        headers: Optional[dict[str, Any]] = None,
    ):
        status_code = ERROR_CODE_TO_HTTP_STATUS.get(
            error_code,
            status.HTTP_500_INTERNAL_SERVER_ERROR
        )
        detail = detail or error_code.value
        super().__init__(status_code=status_code, detail=detail, headers=headers)
        self.error_code = error_code
