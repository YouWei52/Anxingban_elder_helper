from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class LoginRequest(BaseModel):
    phone: str = Field(..., description="手机号")
    password: str = Field(..., description="密码")


class RegisterUserRequest(BaseModel):
    nickname: str = Field(..., description="昵称")
    phone: str = Field(..., description="手机号")
    password: str = Field(..., description="密码")


class RegisterElderRequest(BaseModel):
    name: str = Field(..., description="姓名")
    phone: str = Field(..., description="手机号")
    password: str = Field(..., description="密码")
    health_info: str = Field(default="{}", description="健康信息JSON")
    interests: str = Field(default="", description="兴趣爱好")
    wechat_webhook_url: Optional[str] = Field(default="", description="企业微信Webhook URL")


class TokenResponse(BaseModel):
    access_token: str = Field(..., description="访问令牌")
    token_type: str = Field(default="bearer", description="令牌类型")
    user_type: str = Field(..., description="用户类型: user或elder")
    user_id: int = Field(..., description="用户ID")


class UserInfoResponse(BaseModel):
    id: int
    nickname: str
    phone: str
    last_login_at: Optional[datetime]
    created_at: datetime


class ElderInfoResponse(BaseModel):
    id: int
    name: str
    phone: str
    health_info: str
    interests: str
    wechat_webhook_url: str
    qr_code_svg: str = Field(..., description="老人二维码SVG（供子女扫描）")
    last_login_at: Optional[datetime]
    created_at: datetime
