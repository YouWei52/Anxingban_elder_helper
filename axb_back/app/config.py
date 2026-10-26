"""应用配置管理（基于 Pydantic Settings）"""
from functools import lru_cache
from typing import Optional

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """应用配置"""

    # 应用基础配置
    app_name: str = "anxingban"
    environment: str = "development"
    port: int = 8000

    # 数据库配置
    database_url: str

    # 安全配置
    token_secret: str
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 60 * 24 * 7  # 7天

    # 微信配置
    wechat_webhook_url: Optional[str] = None

    # 短信配置
    sms_provider: str = "mock"  # mock, aliyun, tencent

    # 业务配置
    pilot_city: str = "Chongqing"
    guide_scope: str = "knowledge_limited"

    # 日志配置
    log_level: str = "INFO"
    log_file: str = "logs/app.log"
    log_max_bytes: int = 10 * 1024 * 1024  # 10MB
    log_backup_count: int = 10

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore"
    )


@lru_cache
def get_settings() -> Settings:
    """获取配置单例"""
    return Settings()
