"""任务DTO"""
from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, Field


class TaskCreateDto(BaseModel):
    """创建任务请求"""
    profile_id: int = Field(..., description="档案ID")
    trip_id: int = Field(..., description="行程ID")
    title: str = Field(..., max_length=200, description="任务标题")
    description: Optional[str] = Field(None, description="任务描述")


class TaskCompleteDto(BaseModel):
    """完成任务请求"""
    completed_note: Optional[str] = Field(None, description="完成备注")
    photo_url: Optional[str] = Field(None, description="照片URL")


class TaskFeedbackDto(BaseModel):
    """任务反馈请求"""
    feedback_text: str = Field(..., description="反馈文本")
    hearts_delta: int = Field(0, ge=-10, le=10, description="爱心变化值")


class TaskResponseDto(BaseModel):
    """任务响应"""
    id: int
    trip_id: int
    user_id: int
    title: str
    description: Optional[str] = None
    user_completed: bool
    elder_completed: bool
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
