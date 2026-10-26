# 安行伴配置 (config)

这个目录包含项目的配置文件和文档。

## 目录结构

```
config/
├── doc/                    # 项目文档
│   ├── backend/           # 后端文档
│   ├── frontend/          # 前端文档
│   ├── mobile/            # 移动端文档
│   └── log/               # 开发日志
├── docker-compose.yml     # Docker 编排配置
├── Dockerfile             # 后端镜像构建文件
├── .env.example           # 环境变量模板
└── .env.test.example      # 测试环境变量模板
```

## 环境配置

### 开发环境

1. 复制环境变量模板到项目根目录：
```bash
cp config/.env.example ../.env
```

2. 编辑 `.env` 文件，配置以下必需项：
- `DATABASE_URL`: MySQL 数据库连接字符串
- `TOKEN_SECRET`: JWT Token 密钥

### Docker 部署

```bash
cd config
docker-compose up -d
```

## 文档导航

### API 文档
- [API 标准文档](doc/API标准文档.md) - 完整的 REST API 接口说明

### 架构文档
- [后端架构](doc/backend/后端架构.md) - 技术栈与设计模式
- [前端架构](doc/frontend/部署记录.md) - React 应用架构
- [移动端架构](doc/mobile/移动端架构.md) - Flutter 应用架构

### 部署文档
- [后端部署](doc/backend/后端部署.md) - 后端服务部署步骤
- [前端部署](doc/frontend/部署记录.md) - Web 应用部署流程

### 开发日志
- [用户体系构建](doc/log/0826用户体系构建.md) - 认证系统重构记录
- [用户系统说明](doc/log/USER_SYSTEM.md) - 双端用户体系设计
