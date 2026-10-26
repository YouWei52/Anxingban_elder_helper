"""任务控制器 - 子女用户端"""
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.utils.error_codes import BusinessException, ErrorCode
from app.modules.auth.dependencies import get_current_user
from app.modules.task.dto.TaskDto import (
    TaskCreateDto,
    TaskCompleteDto,
    TaskFeedbackDto,
    TaskResponseDto
)
from app.modules.task.service.TaskService import TaskService

router = APIRouter(prefix="/api/user/tasks", tags=["子女-任务管理"])


@router.post(
    "",
    response_model=TaskResponseDto,
    status_code=status.HTTP_201_CREATED,
    summary="创建任务"
)
def create_task(
    request: TaskCreateDto,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """创建任务"""
    task = TaskService.create_task(db, request, current_user.id)
    return task


@router.get(
    "",
    response_model=list[TaskResponseDto],
    summary="获取任务列表"
)
def list_tasks(
    trip_id: int = None,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取任务列表"""
    if trip_id:
        tasks = TaskService.list_tasks_by_trip(db, trip_id, limit)
    else:
        tasks = TaskService.list_tasks_by_user(db, current_user.id, limit)
    return tasks


@router.get(
    "/{task_id}",
    response_model=TaskResponseDto,
    summary="获取任务详情"
)
def get_task(
    task_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """获取任务详情"""
    task = TaskService.get_task_by_id(db, task_id)
    if not task:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="任务不存在")
    return task


@router.post(
    "/{task_id}/complete",
    response_model=TaskResponseDto,
    summary="完成任务"
)
def complete_task(
    task_id: int,
    request: TaskCompleteDto,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """完成任务（子女侧）"""
    task = TaskService.get_task_by_id(db, task_id)
    if not task:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="任务不存在")

    updated_task = TaskService.complete_task(db, task, request, is_user=True)
    return updated_task


@router.post(
    "/{task_id}/feedback",
    response_model=TaskResponseDto,
    summary="任务反馈"
)
def add_feedback(
    task_id: int,
    request: TaskFeedbackDto,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """添加任务反馈"""
    task = TaskService.get_task_by_id(db, task_id)
    if not task:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="任务不存在")

    updated_task = TaskService.add_feedback(db, task, request)
    return updated_task


@router.delete(
    "/{task_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="删除任务"
)
def delete_task(
    task_id: int,
    db: Session = Depends(get_db),
    current_user=Depends(get_current_user)
):
    """删除任务"""
    task = TaskService.get_task_by_id(db, task_id)
    if not task:
        raise BusinessException(ErrorCode.NOT_FOUND, detail="任务不存在")

    TaskService.delete_task(db, task)
    return None
