from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.utils.database import get_db
from app.modules.auth.dependencies import get_current_elder, get_current_user
from app.modules.auth.dto.AuthDto import (
    ElderInfoResponse,
    LoginRequest,
    RegisterElderRequest,
    RegisterUserRequest,
    TokenResponse,
    UserInfoResponse,
)
from app.modules.auth.service.AuthService import AuthService

router = APIRouter(prefix="/api/auth", tags=["认证"])


@router.post(
    "/user/register",
    response_model=TokenResponse,
    summary="子女用户注册",
    description="注册新的子女用户账号"
)
def register_user(request: RegisterUserRequest, db: Session = Depends(get_db)):
    """子女用户注册"""
    user, token = AuthService.register_user(db, request)
    return TokenResponse(
        access_token=token,
        token_type="bearer",
        user_type="user",
        user_id=user.id
    )


@router.post(
    "/elder/register",
    response_model=TokenResponse,
    summary="老人用户注册",
    description="注册新的老人用户账号"
)
def register_elder(request: RegisterElderRequest, db: Session = Depends(get_db)):
    """老人用户注册"""
    elder, token = AuthService.register_elder(db, request)
    return TokenResponse(
        access_token=token,
        token_type="bearer",
        user_type="elder",
        user_id=elder.id
    )


@router.post(
    "/user/login",
    response_model=TokenResponse,
    summary="子女用户登录",
    description="子女用户登录，返回JWT令牌"
)
def login_user(request: LoginRequest, db: Session = Depends(get_db)):
    """子女用户登录"""
    user, token = AuthService.login_user(db, request.phone, request.password)
    return TokenResponse(
        access_token=token,
        token_type="bearer",
        user_type="user",
        user_id=user.id
    )


@router.post(
    "/elder/login",
    response_model=TokenResponse,
    summary="老人用户登录",
    description="老人用户登录，返回JWT令牌"
)
def login_elder(request: LoginRequest, db: Session = Depends(get_db)):
    """老人用户登录"""
    elder, token = AuthService.login_elder(db, request.phone, request.password)
    return TokenResponse(
        access_token=token,
        token_type="bearer",
        user_type="elder",
        user_id=elder.id
    )


@router.get(
    "/user/me",
    response_model=UserInfoResponse,
    summary="获取当前子女用户信息",
    description="获取当前登录子女用户的详细信息"
)
def get_current_user_info(current_user = Depends(get_current_user)):
    """获取当前子女用户信息"""
    return current_user


@router.get(
    "/elder/me",
    response_model=ElderInfoResponse,
    summary="获取当前老人用户信息",
    description="获取当前登录老人用户的详细信息，包含二维码供子女扫描"
)
def get_current_elder_info(
    current_elder = Depends(get_current_elder),
    db: Session = Depends(get_db)
):
    """获取当前老人用户信息，生成二维码"""
    return AuthService.get_elder_info_with_qr(db, current_elder)
