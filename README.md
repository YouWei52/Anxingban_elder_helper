# 安行伴（重庆试点）

这是一个可本地直接运行的真实产品 MVP，核心目标是帮助子女与长辈在出行过程中实现协同建档、行程安全保障、代际互动和回忆沉淀。

## 系统概览

### 技术架构
- **后端**: FastAPI + SQLAlchemy + MySQL 8.0
- **Web 前端**: React 18 + Vite 5 (PWA)
- **移动端**: Flutter (子女端 + 老人端)
- **认证**: JWT Token 双端用户体系

> 📖 详细架构说明请参考 [后端架构文档](config/doc/backend/后端架构.md)

## 核心功能

1. **认证与用户体系** - 子女端和老人端分离的双用户系统（JWT Token）
2. **家庭协同建档** - 多成员档案管理，包含联系方式、健康信息、兴趣偏好
3. **行程管理** - 创建行程并生成动态通行码（HMAC + SVG 二维码）
4. **紧急求助** - 双通道通知（短信 + 企业微信），支持离线队列
5. **代际任务** - 子女创建任务，长辈完成并获得反馈
6. **景点讲解** - 重庆核心景点的知识问答
7. **数字回忆卡** - 从行程与任务生成回忆摘要

> 📖 完整 API 说明请参考 [API 标准文档](config/doc/API标准文档.md)

## 项目结构

```
├── axb_back/                     # 后端应用包
│   ├── app/                      # 后端应用
│   │   ├── main.py               # FastAPI 入口，路由注册
│   │   ├── config.py             # 配置管理（基于 Pydantic Settings）
│   │   ├── database.py           # 数据库连接和会话管理
│   │   ├── logger.py             # 日志配置
│   │   ├── error_codes.py        # 统一错误码定义
│   │   ├── modules/              # 业务模块（模块化架构）
│   │   │   ├── auth/             # 认证模块（注册、登录、JWT）
│   │   │   ├── profile/          # 家庭档案模块
│   │   │   ├── trip/             # 行程管理模块
│   │   │   ├── task/             # 代际任务模块
│   │   │   ├── sos/              # 紧急求助模块
│   │   │   ├── guide/            # 景点讲解模块
│   │   │   └── card/             # 回忆卡片模块
│   │   │   └── (每个模块包含)
│   │   │       ├── controller/   # API 路由和请求处理
│   │   │       ├── service/      # 业务逻辑层
│   │   │       ├── entity/       # 数据库实体模型
│   │   │       └── dto/          # 数据传输对象
│   │   └── services/             # 共享服务
│   │       ├── pass_token.py     # 动态通行码生成
│   │       ├── notification.py   # 通知服务（短信/企业微信）
│   │       └── ai_guide.py       # AI 讲解服务
│   ├── tests/                    # 测试文件
│   │   ├── test_api.py           # API 集成测试
│   │   ├── test_profile.py       # Profile 模块测试
│   │   ├── test_trip.py          # Trip 模块测试
│   │   └── test_other_modules.py # 其他模块测试
│   ├── scripts/                  # 辅助脚本
│   │   ├── smoke_test.py         # HTTP 级冒烟测试
│   │   └── list_routes.py        # 路由列表工具
│   ├── db/                       # 数据库脚本
│   │   ├── DDL.sql               # 数据库结构定义
│   │   └── DDL_new.sql           # 更新的数据库结构
│   ├── requirements.txt          # Python 依赖
│   ├── pytest.ini                # Pytest 配置
│   └── setup.cfg                 # 变异测试配置
├── axb_front/                    # Web 前端包（React + Vite）
│   ├── src/
│   │   ├── components/           # React 组件
│   │   ├── api/                  # API 客户端
│   │   └── hooks/                # React Hooks
│   ├── pic_frontend/             # 前端展示图片
│   ├── package.json
│   └── vite.config.js
├── axb_mobile/                   # Flutter 移动端包
│   ├── anxingban/                # 子女端 App
│   └── anxingban_user/           # 老人端 App
├── config/                       # 配置包
│   ├── doc/                      # 项目文档
│   │   ├── API标准文档.md        # 完整 API 文档
│   │   ├── backend/              # 后端文档
│   │   ├── frontend/             # 前端文档
│   │   └── mobile/               # 移动端文档
│   ├── docker-compose.yml        # Docker 编排配置
│   ├── Dockerfile                # 后端镜像构建
│   ├── .env.example              # 环境变量模板
│   └── .env.test.example         # 测试环境变量模板
└── README.md                     # 项目说明文档
```

## 快速启动

### 前置要求
- Python 3.10+, MySQL 8.0+
- Node.js 16+ (前端)
- Flutter 3.0+ (移动端)

### 环境配置

```bash
# 1. 复制环境变量模板
cp config/.env.example .env

# 2. 编辑 .env，配置数据库连接和密钥
# DATABASE_URL=mysql+pymysql://user:pass@localhost:3306/anxingban?charset=utf8mb4
# TOKEN_SECRET=your-secret-here
```

> 📖 完整配置说明请参考 [后端部署文档](config/doc/backend/后端部署.md)

### 启动后端

```bash
cd axb_back
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

访问 <http://127.0.0.1:8000/docs> 查看 API 文档

### 启动前端

```bash
cd axb_front
npm install
npm run dev
```

访问 <http://localhost:5173>

### Docker 部署

```bash
cd config
docker-compose up -d
```

> 📖 详细部署步骤请参考 [后端部署文档](config/doc/backend/后端部署.md) 和 [前端部署记录](config/doc/frontend/部署记录.md)

## 项目结构

```
├── axb_back/                 # 后端应用（模块化三层架构）
│   ├── app/                  # FastAPI 应用
│   ├── modules/              # 业务模块（auth/profile/trip/task/sos/guide/card）
│   ├── services/             # 共享服务（通行码/通知/AI讲解）
│   ├── tests/                # 测试文件
│   ├── scripts/              # 辅助脚本
│   └── db/                   # 数据库脚本
├── axb_front/                # Web 前端（React + Vite）
├── axb_mobile/               # Flutter 移动端（子女端 + 老人端）
└── config/                   # 配置和文档
    ├── doc/                  # 项目文档
    ├── docker-compose.yml    # Docker 编排
    └── .env.example          # 环境变量模板
```

> 📖 详细结构说明请参考 [后端架构文档](config/doc/backend/后端架构.md)

## 测试

```bash
# 后端测试（需要独立测试数据库）
cd axb_back
TEST_DATABASE_URL='mysql+pymysql://user:pass@localhost:3306/anxingban_test?charset=utf8mb4' \
  python -m pytest -v

# 冒烟测试
python scripts/smoke_test.py
```

## 技术文档

- [API 标准文档](config/doc/API标准文档.md) - 完整的 API 接口说明
- [后端架构文档](config/doc/backend/后端架构.md) - 技术栈与设计模式
- [后端部署文档](config/doc/backend/后端部署.md) - 部署步骤与配置说明
- [前端部署记录](config/doc/frontend/部署记录.md) - 前端部署流程
- [移动端架构](config/doc/mobile/移动端架构.md) - Flutter 应用架构
- [老人端适配总结](config/doc/mobile/老人端适配总结.md) - 老人端 UI/UX 设计

## 开发日志

- [用户体系构建](config/doc/log/0826用户体系构建.md) - v2.0 认证系统重构记录
- [用户系统说明](config/doc/log/USER_SYSTEM.md) - 双端用户体系设计

## 许可证

暂无

