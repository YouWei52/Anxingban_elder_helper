"""档案DTO"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, Field


class ProfileCreateDto(BaseModel):
    """创建档案请求"""
    elder_id: int = Field(..., description="老人用户ID")
    user_id: int = Field(..., description="子女用户ID")
    relationship: Optional[str] = Field(None, max_length=50, description="关系")
    emergency_contact: Optional[str] = Field(None, max_length=20, description="紧急联系人电话")
    notes: Optional[str] = Field(None, description="备注信息")


class ProfileUpdateDto(BaseModel):
    """更新档案请求"""
    relationship: Optional[str] = Field(None, max_length=50, description="关系")
    emergency_contact: Optional[str] = Field(None, max_length=20, description="紧急联系人电话")
    notes: Optional[str] = Field(None, description="备注信息")


class ProfileResponseDto(BaseModel):
    """档案响应"""
    id: int
    elder_id: int
    user_id: int
    relationship: Optional[str] = None
    emergency_contact: Optional[str] = None
    notes: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
