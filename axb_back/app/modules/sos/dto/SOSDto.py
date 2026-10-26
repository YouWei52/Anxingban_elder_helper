"""紧急求助DTO"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, Field


class SOSTriggerDto(BaseModel):
    """触发SOS请求"""
    profile_id: int = Field(..., description="档案ID")
    trip_id: Optional[int] = Field(None, description="行程ID")
    latitude: Optional[float] = Field(None, description="纬度")
    longitude: Optional[float] = Field(None, description="经度")
    network_status: str = Field("online", description="网络状态")
    message: Optional[str] = Field(None, description="求助信息")


class SOSResponseDto(BaseModel):
    """SOS响应"""
    id: int
    elder_id: int
    trip_id: Optional[int] = None
    location: Optional[str] = None
    message: Optional[str] = None
    status: str
    created_at: datetime
    resolved_at: Optional[datetime] = None

    model_config = ConfigDict(from_attributes=True)
