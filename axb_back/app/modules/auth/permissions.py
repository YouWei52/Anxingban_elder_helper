"""权限管理模块 - 基于 fastapi-permissions"""
from typing import Union
from fastapi_permissions import configure_permissions, Everyone, Authenticated

from app.modules.auth.entity.UserEntity import UserEntity
from app.modules.auth.entity.ElderEntity import ElderEntity


def get_active_principals(user: Union[UserEntity, ElderEntity, None]) -> list:
    """
    获取用户的身份标识列表（Principals）

    Principals 是权限系统用来识别用户身份的标识符列表。

    Args:
        user: 当前登录的用户（UserEntity 或 ElderEntity）

    Returns:
        身份标识列表，例如：
        - [Everyone]  # 未登录用户
        - [Everyone, Authenticated, "user:123", "role:user"]  # 普通子女用户
        - [Everyone, Authenticated, "elder:456", "role:elder"]  # 普通老人用户
        - [Everyone, Authenticated, "user:1", "role:admin"]  # 管理员
    """
    if user is None:
        return [Everyone]

    principals = [Everyone, Authenticated]

    # 添加用户ID标识（用于资源所有权检查）
    if hasattr(user, 'id'):
        # 判断用户类型
        if isinstance(user, ElderEntity):
            principals.append(f"elder:{user.id}")
        else:  # UserEntity
            principals.append(f"user:{user.id}")

    # 添加角色标识（用于角色权限检查）
    if hasattr(user, 'role') and user.role:
        principals.append(f"role:{user.role}")

    return principals


# 创建权限依赖函数
# 用法: permission = Permission("edit", resource)
Permission = configure_permissions(get_active_principals)
