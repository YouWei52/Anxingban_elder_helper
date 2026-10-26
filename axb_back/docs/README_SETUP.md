# 安行伴后端 - 快速开始指南

## 方式一：Docker Compose（推荐，最简单）

### 前置要求
- Docker 20.10+
- Docker Compose 2.0+

### 启动步骤

```bash
# 1. 进入后端目录
cd axb_back

# 2. 启动所有服务（MySQL + 后端）
docker-compose up -d

# 3. 查看日志
docker-compose logs -f backend

# 4. 访问服务
# API文档: http://localhost:8000/docs
# 健康检查: http://localhost:8000/health
```

### 管理命令

```bash
# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看运行状态
docker-compose ps

# 进入后端容器
docker-compose exec backend bash

# 进入MySQL容器
docker-compose exec mysql mysql -uroot -proot anxingban
```

---

## 方式二：本地开发

### 前置要求
- Python 3.11+
- MySQL 8.0+
- pip

### 1. 安装依赖

```bash
# 创建虚拟环境
python -m venv .venv

# 激活虚拟环境
source .venv/bin/activate  # Linux/Mac
# 或
.venv\Scripts\activate  # Windows

# 安装依赖
pip install -r requirements.txt
```

### 2. 配置环境变量

```bash
# 复制配置模板
cp .env.example .env

# 生成安全密钥
python -c "import secrets; print('SECRET_KEY=' + secrets.token_urlsafe(32))"
python -c "import secrets; print('TOKEN_SECRET=' + secrets.token_urlsafe(32))"

# 编辑 .env 文件，填入以下配置：
# - DATABASE_URL: 你的MySQL连接字符串
# - SECRET_KEY: 上面生成的密钥
# - TOKEN_SECRET: 上面生成的密钥
```

### 3. 初始化数据库

```bash
# 创建数据库和用户
mysql -u root -p << EOF
CREATE DATABASE IF NOT EXISTS anxingban CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'ivan'@'localhost' IDENTIFIED BY '123456';
GRANT ALL PRIVILEGES ON anxingban.* TO 'ivan'@'localhost';
FLUSH PRIVILEGES;
EOF

# 导入表结构
mysql -u ivan -p123456 anxingban < db/DDL.sql

# 验证表是否创建成功
mysql -u ivan -p123456 anxingban -e "SHOW TABLES;"
```

### 4. 启动服务

```bash
# 开发模式（带热重载）
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

# 或使用Python直接运行
python -m app.main
```

### 5. 访问服务

- API文档（Swagger）: http://localhost:8000/docs
- API文档（ReDoc）: http://localhost:8000/redoc
- 健康检查: http://localhost:8000/health

---

## 测试

### 运行测试

```bash
# 运行所有测试
pytest -v

# 运行特定模块测试
pytest tests/auth/ -v

# 生成覆盖率报告
pytest --cov=app --cov-report=html

# 查看覆盖率报告
open htmlcov/index.html  # Mac
# 或
xdg-open htmlcov/index.html  # Linux
```

### 冒烟测试

```bash
# 运行冒烟测试（验证核心功能）
python scripts/smoke_test.py
```

---

## 常见问题

### 1. 数据库连接失败

**错误**: `Can't connect to MySQL server`

**解决方案**:
```bash
# 检查MySQL是否运行
mysql -u ivan -p123456 -e "SELECT 1;"

# 检查.env中的DATABASE_URL配置是否正确
# 格式: mysql+pymysql://ivan:123456@localhost:3306/anxingban?charset=utf8mb4
# Docker环境下主机名应为mysql而非localhost
```

### 2. 端口被占用

**错误**: `Address already in use`

**解决方案**:
```bash
# 查看占用8000端口的进程
lsof -i :8000  # Mac/Linux
# 或
netstat -ano | findstr :8000  # Windows

# 杀死进程或修改.env中的PORT配置
```

### 3. 导入错误

**错误**: `ModuleNotFoundError: No module named 'app'`

**解决方案**:
```bash
# 确保在axb_back目录下运行
pwd  # 应显示 .../axb_back

# 确保虚拟环境已激活
which python  # 应显示 .venv/bin/python
```

### 4. 权限错误（Docker）

**错误**: `Permission denied` 在logs目录

**解决方案**:
```bash
# 创建logs目录并设置权限
mkdir -p logs
chmod 777 logs
```

---

## 配置说明

### 必须配置的项目

- `DATABASE_URL`: MySQL连接字符串
- `SECRET_KEY`: JWT签名密钥（生产环境必须修改）
- `TOKEN_SECRET`: 通行码签名密钥（生产环境必须修改）

### 可选配置项目

- `AGENT_ENABLED`: 是否启用Agent功能（默认false）
- `SMS_PROVIDER`: 短信提供商（默认mock）
- `WECHAT_WEBHOOK_URL`: 企业微信通知URL
- `LOG_LEVEL`: 日志级别（默认INFO）

完整配置说明请参考 `../.env.example` 文件中的注释。

---

## 生产环境部署

### 安全检查清单

- [ ] 修改 `SECRET_KEY` 和 `TOKEN_SECRET` 为强随机密钥
- [ ] 设置 `ENVIRONMENT=production`
- [ ] 配置实际的短信服务（阿里云/腾讯云）
- [ ] 限制CORS允许的域名（修改 `../app/main.py`）
- [ ] 使用HTTPS
- [ ] 配置反向代理（Nginx/Caddy）
- [ ] 设置防火墙规则
- [ ] 配置日志轮转
- [ ] 定期备份数据库

### 推荐部署方式

```bash
# 使用gunicorn + uvicorn worker
gunicorn app.main:app \
  --workers 4 \
  --worker-class uvicorn.workers.UvicornWorker \
  --bind 0.0.0.0:8000 \
  --access-logfile logs/access.log \
  --error-logfile logs/error.log
```

---

## 开发建议

### 代码风格

```bash
# 安装开发工具
pip install black ruff mypy

# 格式化代码
black app/

# 检查代码质量
ruff check app/

# 类型检查
mypy app/
```

### Git工作流

```bash
# 创建功能分支
git checkout -b feature/your-feature

# 提交代码
git add .
git commit -m "feat: 添加新功能"

# 推送到远程
git push origin feature/your-feature
```

---

## 获取帮助

- 查看完整项目文档: `1011.md`
- 查看API文档: http://localhost:8000/docs
- 提交Issue: GitHub Issues
