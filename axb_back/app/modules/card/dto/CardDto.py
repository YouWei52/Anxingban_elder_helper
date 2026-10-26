from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict, Field


class CardGenerateDto(BaseModel):
    trip_id: int
    title: str = Field(default="Travel Memory Card", max_length=120)
    image_url: str = Field(default="", max_length=400)


class CardResponseDto(BaseModel):
    id: int
    trip_id: int
    title: str
    summary: str
    image_url: Optional[str] = None
    card_json: str
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
