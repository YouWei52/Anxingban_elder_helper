"""景点讲解控制器 - 老人用户端"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.modules.auth.dependencies import get_current_elder
from app.modules.guide.dto.GuideDto import GuideAskDto, GuideResponseDto
from app.modules.guide.service.GuideService import GuideService

router = APIRouter(prefix="/api/elder/guide", tags=["老人-景点讲解"])


@router.post(
    "/ask",
    response_model=GuideResponseDto,
    summary="景点智能问答（老人）"
)
def ask_guide(
    request: GuideAskDto,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """景点智能问答"""
    response = GuideService.answer_question(request.question)
    return response
