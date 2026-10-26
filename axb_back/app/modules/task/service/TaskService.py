"""任务业务逻辑层"""
from sqlalchemy.orm import Session

from app.modules.task.dto.TaskDto import TaskCreateDto, TaskCompleteDto, TaskFeedbackDto
from app.modules.task.entity.TaskEntity import TaskEntity
from app.modules.task.repository.TaskRepository import TaskRepository
from app.modules.trip.repository.TripRepository import TripRepository
from app.utils.error_codes import BusinessException, ErrorCode


class TaskService:
    """任务业务逻辑"""

    @staticmethod
    def create_task(db: Session, data: TaskCreateDto, user_id: int) -> TaskEntity:
        """创建任务"""
        # 验证行程是否存在
        trip_repo = TripRepository(db)
        trip = trip_repo.find_by_id(data.trip_id)
        if not trip:
            raise BusinessException(ErrorCode.NOT_FOUND, detail="行程不存在")

        # 创建任务
        task = TaskEntity(
            trip_id=data.trip_id,
            user_id=user_id,
            title=data.title,
            description=data.description,
            user_completed=False,
            elder_completed=False
        )

        repo = TaskRepository(db)
        return repo.create(task)

    @staticmethod
    def get_task_by_id(db: Session, task_id: int) -> TaskEntity | None:
        """根据ID获取任务"""
        repo = TaskRepository(db)
        return repo.find_by_id(task_id)

    @staticmethod
    def list_tasks_by_trip(db: Session, trip_id: int, limit: int = 100) -> list[TaskEntity]:
        """根据行程ID获取任务列表"""
        repo = TaskRepository(db)
        return repo.find_by_trip_id(trip_id, limit)

    @staticmethod
    def list_tasks_by_user(db: Session, user_id: int, limit: int = 100) -> list[TaskEntity]:
        """根据子女用户ID获取任务列表"""
        repo = TaskRepository(db)
        return repo.find_by_user_id(user_id, limit)

    @staticmethod
    def list_all_tasks(db: Session, limit: int = 100) -> list[TaskEntity]:
        """获取所有任务"""
        repo = TaskRepository(db)
        return repo.find_all(limit)

    @staticmethod
    def complete_task(db: Session, task: TaskEntity, data: TaskCompleteDto, is_user: bool) -> TaskEntity:
        """完成任务

        Args:
            task: 任务实体
            data: 完成数据
            is_user: True=子女完成, False=老人完成
        """
        if is_user:
            task.user_completed = True
        else:
            task.elder_completed = True

        repo = TaskRepository(db)
        return repo.update(task)

    @staticmethod
    def add_feedback(db: Session, task: TaskEntity, data: TaskFeedbackDto) -> TaskEntity:
        """添加任务反馈"""
        # 这里可以扩展更多反馈逻辑
        # 目前仅更新任务状态
        repo = TaskRepository(db)
        return repo.update(task)

    @staticmethod
    def delete_task(db: Session, task: TaskEntity) -> None:
        """删除任务"""
        repo = TaskRepository(db)
        repo.delete(task)
