"""景点讲解DTO"""
from pydantic import BaseModel, Field


class GuideAskDto(BaseModel):
    """景点问答请求"""
    question: str = Field(..., min_length=1, max_length=500, description="问题")


class GuideResponseDto(BaseModel):
    """景点问答响应"""
    answer: str = Field(..., description="回答")
    confidence: float = Field(..., ge=0.0, le=1.0, description="置信度")
    scope: str = Field(default="knowledge_limited", description="知识范围")
