import json

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.modules.card.entity.MemoryCardEntity import MemoryCardEntity
from app.modules.card.repository.CardRepository import CardRepository
from app.modules.task.entity.TaskEntity import TaskEntity


class CardService:
    @staticmethod
    def generate_card(db: Session, trip_id: int, title: str, image_url: str, trip_entity) -> MemoryCardEntity:
        tasks = db.scalars(select(TaskEntity).where(TaskEntity.trip_id == trip_id)).all()
        completed_tasks = [t.title for t in tasks if (t.user_completed and t.elder_completed)]
        summary = f"Trip to {trip_entity.destination} on {trip_entity.travel_date}. Completed tasks: {', '.join(completed_tasks) if completed_tasks else 'none yet'}."

        card_data = {
            "pilot_city": "Chongqing",
            "destination": trip_entity.destination,
            "travel_date": str(trip_entity.travel_date),
            "completed_tasks": completed_tasks,
        }
        repo = CardRepository(db)
        card = MemoryCardEntity(
            trip_id=trip_id,
            title=title,
            summary=summary,
            image_url=image_url,
            card_json=json.dumps(card_data, ensure_ascii=True),
        )
        return repo.create(card)

    @staticmethod
    def get_card_by_id(db: Session, card_id: int) -> MemoryCardEntity | None:
        repo = CardRepository(db)
        return repo.find_by_id(card_id)

    @staticmethod
    def list_cards_by_trip(db: Session, trip_id: int) -> list[MemoryCardEntity]:
        repo = CardRepository(db)
        return repo.find_by_trip(trip_id)

    @staticmethod
    def list_cards_by_profile(db: Session, profile_id: int) -> list[MemoryCardEntity]:
        repo = CardRepository(db)
        return repo.find_by_profile(profile_id)

    @staticmethod
    def list_all_cards(db: Session, limit: int = 100) -> list[MemoryCardEntity]:
        repo = CardRepository(db)
        return repo.find_all(limit)

    @staticmethod
    def delete_card(db: Session, card_id: int) -> None:
        repo = CardRepository(db)
        card = repo.find_by_id(card_id)
        if card:
            repo.delete(card)
