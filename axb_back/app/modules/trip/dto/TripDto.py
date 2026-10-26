"""行程DTO"""
from datetime import date, datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, Field


class TripCreateDto(BaseModel):
    """创建行程请求"""
    profile_id: int = Field(..., description="档案ID")
    destination: str = Field(..., max_length=200, description="目的地")
    travel_date: date = Field(..., description="出行日期")
    notes: Optional[str] = Field(None, description="备注")


class TripResponseDto(BaseModel):
    """行程响应"""
    id: int
    profile_id: int
    elder_id: int
    destination: str
    travel_date: date
    notes: Optional[str] = None
    pass_token: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class TripPassResponseDto(BaseModel):
    """行程通行码响应"""
    trip_id: int
    pass_token: str
    pass_qr_svg: str
    destination: str
    travel_date: date
