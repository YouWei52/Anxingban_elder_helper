"""卡片控制器"""
from app.modules.card.controller.CardController import router as card_router
from app.modules.card.controller.CardElderController import router as card_elder_router

__all__ = ["card_router", "card_elder_router"]
