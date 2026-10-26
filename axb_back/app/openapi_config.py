"""自定义OpenAPI Schema配置 - 添加JWT认证支持"""


def custom_openapi_schema(app):
    """
    自定义OpenAPI Schema，添加JWT Bearer认证配置

    这使得Swagger UI可以显示"Authorize"按钮，
    用户可以输入JWT Token进行认证测试
    """
    if app.openapi_schema:
        return app.openapi_schema

    from fastapi.openapi.utils import get_openapi

    openapi_schema = get_openapi(
        title=app.title,
        version=app.version,
        description=app.description,
        routes=app.routes,
    )

    # 添加安全方案定义
    openapi_schema["components"]["securitySchemes"] = {
        "BearerAuth": {
            "type": "http",
            "scheme": "bearer",
            "bearerFormat": "JWT",
            "description": "输入JWT Token（从 /api/auth/user/login 或 /api/auth/elder/login 获取）"
        }
    }

    # 为所有需要认证的路由添加安全要求
    for path_data in openapi_schema["paths"].values():
        for operation in path_data.values():
            if isinstance(operation, dict):
                # 排除不需要认证的路由（如登录、注册、健康检查）
                if operation.get("operationId") not in [
                    "register_user_api_auth_user_register_post",
                    "register_elder_api_auth_elder_register_post",
                    "login_user_api_auth_user_login_post",
                    "login_elder_api_auth_elder_login_post",
                    "root__get",
                    "health_check_health_get"
                ]:
                    # 添加安全要求
                    operation["security"] = [{"BearerAuth": []}]

    app.openapi_schema = openapi_schema
    return app.openapi_schema
