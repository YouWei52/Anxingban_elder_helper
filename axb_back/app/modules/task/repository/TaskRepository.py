"""任务数据访问层"""
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.modules.task.entity.TaskEntity import TaskEntity


class TaskRepository:
    """Task数据访问层"""

    def __init__(self, db: Session):
        self.db = db

    def find_by_id(self, task_id: int) -> TaskEntity | None:
        """根据ID查询任务"""
        return self.db.get(TaskEntity, task_id)

    def find_by_trip_id(self, trip_id: int, limit: int = 100) -> list[TaskEntity]:
        """根据行程ID查询任务列表"""
        return list(self.db.scalars(
            select(TaskEntity)
            .where(TaskEntity.trip_id == trip_id)
            .order_by(TaskEntity.id.desc())
            .limit(limit)
        ).all())

    def find_by_user_id(self, user_id: int, limit: int = 100) -> list[TaskEntity]:
        """根据子女用户ID查询任务列表"""
        return list(self.db.scalars(
            select(TaskEntity)
            .where(TaskEntity.user_id == user_id)
            .order_by(TaskEntity.id.desc())
            .limit(limit)
        ).all())

    def find_all(self, limit: int = 100) -> list[TaskEntity]:
        """查询所有任务"""
        return list(self.db.scalars(
            select(TaskEntity)
            .order_by(TaskEntity.id.desc())
            .limit(limit)
        ).all())

    def create(self, task: TaskEntity) -> TaskEntity:
        """创建任务"""
        self.db.add(task)
        self.db.commit()
        self.db.refresh(task)
        return task

    def update(self, task: TaskEntity) -> TaskEntity:
        """更新任务"""
        self.db.commit()
        self.db.refresh(task)
        return task

    def delete(self, task: TaskEntity) -> None:
        """删除任务"""
        self.db.delete(task)
        self.db.commit()
