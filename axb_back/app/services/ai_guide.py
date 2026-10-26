from __future__ import annotations

from dataclasses import dataclass


@dataclass
class KnowledgeItem:
    keys: tuple[str, ...]
    answer: str


KNOWLEDGE_BASE = [
    KnowledgeItem(
        keys=("hongya", "hongyadong", "cave"),
        answer="Hongya Cave is a riverfront stilt-house complex in Chongqing, best visited after sunset for skyline views.",
    ),
    KnowledgeItem(
        keys=("ciqikou", "old town", "porcelain"),
        answer="Ciqikou Old Town is known for tea houses, local snacks, and traditional lanes. Weekday mornings are less crowded.",
    ),
    KnowledgeItem(
        keys=("three gorges", "museum", "history"),
        answer="Three Gorges Museum presents Chongqing history and Yangtze River culture. Plan 1.5 to 2 hours for a calm visit.",
    ),
    KnowledgeItem(
        keys=("cableway", "yangtze"),
        answer="Yangtze River Cableway gives short panoramic crossings. Avoid rush hours around sunset to reduce waiting time.",
    ),
    KnowledgeItem(
        keys=("dazu", "rock", "carvings"),
        answer="Dazu Rock Carvings are UNESCO heritage Buddhist sites. Comfortable walking shoes are recommended.",
    ),
]


def answer_question(question: str) -> tuple[str, float]:
    q = question.lower().strip()
    if not q:
        return "Please enter a question about Chongqing attractions.", 0.0

    best_score = 0
    best_answer = "I currently provide limited Chongqing knowledge. Try asking about Hongya Cave, Ciqikou, Cableway, Dazu, or museums."

    for item in KNOWLEDGE_BASE:
        score = sum(1 for key in item.keys if key in q)
        if score > best_score:
            best_score = score
            best_answer = item.answer

    confidence = min(1.0, best_score / 2) if best_score > 0 else 0.2
    return best_answer, confidence
