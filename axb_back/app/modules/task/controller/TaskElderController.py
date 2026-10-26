"""任务控制器 - 老人用户端"""
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_elder
from app.modules.task.dto.TaskDto import TaskResponseDto
from app.modules.task.service.TaskService import TaskService

router = APIRouter(prefix="/api/elder/tasks", tags=["老人-任务管理"])


@router.get(
    "",
    response_model=list[TaskResponseDto],
    summary="获取任务列表（老人）"
)
def list_tasks(
    trip_id: int = None,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取任务列表（只读）"""
    if trip_id:
        tasks = TaskService.list_tasks_by_trip(db, trip_id, limit)
    else:
        tasks = TaskService.list_all_tasks(db, limit)
    return tasks


@router.get(
    "/{task_id}",
    response_model=TaskResponseDto,
    summary="获取任务详情（老人）"
)
def get_task(
    task_id: int,
    db: Session = Depends(get_db),
    current_elder=Depends(get_current_elder)
):
    """获取任务详情（只读）"""
    task = TaskService.get_task_by_id(db, task_id)
    if not task:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="任务不存在")
    return task
