from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_user
from app.modules.card.dto.CardDto import CardResponseDto
from app.modules.card.service.CardService import CardService

router = APIRouter(prefix="/api/user/cards", tags=["子女-回忆卡片"])


@router.get(
    "/{card_id}",
    response_model=CardResponseDto,
    summary="获取卡片详情"
)
def get_card(
    card_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """获取卡片详情"""
    card = CardService.get_card_by_id(db, card_id)
    if not card:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="卡片不存在")
    return card


@router.get(
    "",
    response_model=list[CardResponseDto],
    summary="获取卡片列表",
    description="查询卡片列表，支持按档案ID或行程ID筛选"
)
def list_cards(
    profile_id: int = None,
    trip_id: int = None,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """获取卡片列表"""
    if profile_id:
        return CardService.list_cards_by_profile(db, profile_id)
    elif trip_id:
        return CardService.list_cards_by_trip(db, trip_id)
    else:
        return CardService.list_all_cards(db, limit)


@router.delete(
    "/{card_id}",
    summary="删除卡片"
)
def delete_card(
    card_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """删除卡片"""
    card = CardService.get_card_by_id(db, card_id)
    if not card:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="卡片不存在")
    
    CardService.delete_card(db, card_id)
    return {"message": "卡片删除成功"}
