# 安行伴后端

基于 FastAPI 的后端服务，为老年人出行提供安全保障和代际互动功能。

## 功能模块

- **认证系统** - 子女端和老人端双用户体系（JWT Token）
- **家庭档案** - 多成员档案管理，包含联系方式、健康信息、兴趣偏好
- **行程管理** - 创建行程并生成动态通行码
- **紧急求助** - 双通道通知（短信 + 企业微信）
- **代际任务** - 子女创建任务，长辈完成并获得反馈
- **景点讲解** - 重庆核心景点的知识问答
- **数字回忆卡** - 从行程与任务生成回忆摘要

## 技术栈

- **框架**: FastAPI 0.115+
- **数据库**: SQLAlchemy 2.0 + MySQL 8.0
- **认证**: JWT + bcrypt
- **配置管理**: Pydantic Settings
- **日志**: Python logging with rotation

## 项目结构

```
axb_back/
├── app/
│   ├── main.py              # FastAPI 应用入口
│   ├── config.py            # 配置管理
│   ├── database.py          # 数据库连接
│   ├── logger.py            # 日志配置
│   ├── modules/             # 业务模块
│   │   ├── auth/            # 认证模块
│   │   ├── profile/         # 档案模块
│   │   ├── trip/            # 行程模块
│   │   ├── task/            # 任务模块
│   │   ├── sos/             # 求助模块
│   │   ├── guide/           # 讲解模块
│   │   └── card/            # 回忆卡片模块
│   ├── services/            # 共享服务
│   └── utils/               # 工具函数
├── tests/                   # 测试文件
├── scripts/                 # 辅助脚本
├── logs/                    # 日志目录
├── requirements.txt         # 依赖包
└── pytest.ini              # 测试配置
```

## 快速开始

### 1. 环境配置

```bash
# 创建虚拟环境
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate

# 安装依赖
pip install -r requirements.txt

# 配置环境变量
cp ../.env.example .env
# 编辑 .env 文件，设置数据库连接和密钥
```

### 2. 数据库初始化

```bash
# 创建数据库
mysql -u root -p -e "CREATE DATABASE anxingban CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 运行应用会自动创建表（开发环境）
# 生产环境建议使用 Alembic 进行数据库迁移
```

### 3. 启动服务

```bash
# 开发模式（带热重载）
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload

# 或使用 Python 直接运行
python -m app.main
```

访问 http://127.0.0.1:8000/docs 查看 API 文档

### 4. 运行测试

```bash
# 设置测试数据库
export TEST_DATABASE_URL='mysql+pymysql://user:pass@localhost:3306/anxingban_test?charset=utf8mb4'

# 运行所有测试
pytest -v

# 运行特定测试
pytest tests/auth/ -v
```

## 环境变量

在 `.env` 文件中配置以下变量：

```env
# 数据库配置
DATABASE_URL=mysql+pymysql://username:password@localhost:3306/anxingban?charset=utf8mb4

# 安全配置
SECRET_KEY=your-jwt-secret-key-here
TOKEN_SECRET=your-token-secret-here

# 应用配置
APP_NAME=anxingban
ENVIRONMENT=development
PORT=8000

# 日志配置
LOG_LEVEL=INFO
LOG_FILE=logs/app.log
```

## API 文档

启动服务后访问：
- Swagger UI: http://127.0.0.1:8000/docs
- ReDoc: http://127.0.0.1:8000/redoc

## 开发指南

### 模块结构

每个业务模块遵循以下结构：
```
module_name/
├── controller/    # API 路由和请求处理
├── service/       # 业务逻辑层
├── repository/    # 数据访问层
├── entity/        # 数据库实体模型
└── dto/          # 数据传输对象
```

### 添加新模块

1. 在 `app/modules/` 下创建模块目录
2. 实现 entity、repository、service、controller
3. 在 `app/main.py` 中注册路由

## 部署

### Docker 部署

参考项目根目录的 `config/docker-compose.yml`

### 生产环境配置

1. 设置 `ENVIRONMENT=production`
2. 使用强随机密钥（`python -c "import secrets; print(secrets.token_urlsafe(32))"`）
3. 配置 HTTPS
4. 限制 CORS 允许的域名
5. 使用数据库迁移工具（Alembic）

## 许可证

暂无
