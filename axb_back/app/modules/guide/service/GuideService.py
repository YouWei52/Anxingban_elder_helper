"""景点讲解业务逻辑层"""
from app.modules.guide.dto.GuideDto import GuideResponseDto
from app.services.ai_guide import answer_question
from app.config import get_settings

settings = get_settings()


class GuideService:
    """景点讲解业务逻辑"""

    @staticmethod
    def answer_question(question: str) -> GuideResponseDto:
        """回答景点相关问题"""
        answer, confidence = answer_question(question)

        return GuideResponseDto(
            answer=answer,
            confidence=confidence,
            scope=settings.guide_scope
        )
