# 用户体系说明文档

## 概述

安行伴系统现已完成用户体系重构，支持两类用户：

- **子女用户（User）**：完整的系统管理权限
- **老人用户（Elder）**：受限的只读和部分操作权限

## 数据库结构

### 新增表

#### 1. users（子女用户表）

```sql
- id: 用户ID（主键）
- nickname: 昵称
- phone: 手机号（唯一）
- password_hash: 密码哈希
- last_login_at: 最后登录时间
- created_at: 创建时间
```

#### 2. elders（老人表）

```sql
- id: 老人ID（主键）
- name: 姓名
- phone: 手机号（唯一）
- password_hash: 密码哈希
- health_info: 健康信息JSON
- interests: 兴趣爱好
- wechat_webhook_url: 企业微信Webhook URL
- last_login_at: 最后登录时间
- created_at: 创建时间
```

#### 3. profiles（档案关联表）

```sql
- id: 档案ID（主键）
- elder_id: 老人ID（外键）
- user_id: 子女用户ID（外键）
- created_at: 创建时间
```

## 认证系统

### JWT令牌机制

- **令牌有效期**：7天
- **自动续期**：每次登录自动刷新last_login_at
- **口令缓存**：连续7天不登录才过期，登录则持续保持

### 密码复杂度要求

密码必须满足以下条件：

1. 至少8个字符
2. 包含至少一个大写字母
3. 包含至少一个小写字母
4. 包含至少一个数字
5. 包含至少一个特殊字符

示例有效密码：`MyPass123!`

## API权限划分

### 认证API（/api/auth）

| 端点 | 方法 | 说明 |
| ------ | ------ | ------ |
| `/api/auth/user/register` | POST | 子女用户注册 |
| `/api/auth/user/login` | POST | 子女用户登录 |
| `/api/auth/user/me` | GET | 获取当前子女用户信息 |
| `/api/auth/elder/register` | POST | 老人用户注册 |
| `/api/auth/elder/login` | POST | 老人用户登录 |
| `/api/auth/elder/me` | GET | 获取当前老人用户信息 |

### 子女用户API（/api/user）- 完整权限

子女用户拥有所有API的完整CRUD权限：

| 模块 | 前缀 | 权限 |
| ------ | ------ | ------ |
| 档案管理 | `/api/user/profiles` | GET, POST, PATCH, PUT, DELETE |
| 行程管理 | `/api/user/trips` | GET, POST, DELETE |
| 亲子任务 | `/api/user/tasks` | GET, POST, PATCH, DELETE |
| 紧急求助 | `/api/user/sos` | GET, POST |
| 回忆卡片 | `/api/user/cards` | GET, POST, DELETE |
| 景点讲解 | `/api/user/guide` | POST |

### 老人用户API（/api/elder）- 受限权限

老人用户只有特定的只读和操作权限：

| 模块 | 前缀 | 权限 | 说明 |
| ------ | ------ | ------ | ------ |
| 档案管理 | `/api/elder/profiles` | **GET** | 只读 |
| 行程管理 | `/api/elder/trips` | **GET** | 只读 |
| 亲子任务 | `/api/elder/tasks` | **GET** | 只读 |
| 紧急求助 | `/api/elder/sos` | **GET, POST** | 可触发SOS |
| 回忆卡片 | `/api/elder/cards` | **GET, POST, DELETE** | 完整操作 |
| 景点讲解 | `/api/elder/guide` | **POST** | 完整操作 |

## 使用示例

### 1. 子女用户注册

```bash
POST /api/auth/user/register
Content-Type: application/json

{
  "nickname": "张三",
  "phone": "13800138000",
  "password": "MyPass123!"
}
```

响应：

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "token_type": "bearer",
  "user_type": "user",
  "user_id": 1
}
```

### 2. 老人用户注册

```bash
POST /api/auth/elder/register
Content-Type: application/json

{
  "name": "李奶奶",
  "phone": "13900139000",
  "password": "ElderPass123!",
  "health_info": "{\"chronic_diseases\": \"高血压\", \"allergies\": \"无\"}",
  "interests": "文化,美食,历史"
}
```

### 3. 登录并使用令牌

```bash
# 登录
POST /api/auth/user/login
Content-Type: application/json

{
  "phone": "13800138000",
  "password": "MyPass123!"
}

# 使用令牌访问受保护的API
GET /api/user/profiles
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

### 4. 老人用户触发SOS

```bash
POST /api/elder/sos/trigger
Authorization: Bearer <elder_token>
Content-Type: application/json

{
  "profile_id": 1,
  "trip_id": 5,
  "latitude": 29.5630,
  "longitude": 106.5516,
  "network_status": "online"
}
```

## 安全特性

1. **密码加密**：使用bcrypt算法存储密码哈希
2. **JWT签名**：使用HS256算法签名JWT令牌
3. **令牌过期**：7天自动过期机制
4. **权限隔离**：子女和老人API严格隔离
5. **中间件认证**：所有受保护端点都需要JWT认证

## 迁移指南

### 数据库迁移

1. 备份现有数据库
2. 执行新的DDL脚本：`db/DDL_new.sql`
3. 迁移现有profiles数据到新结构（需要手动处理）

### API调用更新

**旧的API前缀**：`/api/app/*`
**新的API前缀**：

- 子女用户：`/api/user/*`
- 老人用户：`/api/elder/*`

所有API调用都需要在Header中添加JWT令牌：

```
Authorization: Bearer <token>
```

## 配置说明

在`.env`文件中添加：

```env
SECRET_KEY=your-secret-key-change-in-production-jwt-signing
```

## 依赖安装

新增依赖包：

```bash
pip install passlib bcrypt PyJWT python-multipart
```

或使用：

```bash
pip install -r requirements_auth.txt
```

## 开发建议

1. **测试账号**：建议创建测试用的子女和老人账号
2. **令牌管理**：前端需要实现令牌存储和自动刷新
3. **错误处理**：注意处理401（未授权）和403（无权限）错误
4. **日志监控**：关注认证相关的日志记录

## 常见问题

### Q: 如何处理令牌过期？

A: 当收到401错误时，引导用户重新登录获取新令牌。

### Q: 老人用户能创建行程吗？

A: 不能，老人用户只能查看行程，创建行程需要子女用户权限。

### Q: 如何关联老人和子女？

A: 通过profiles表关联，一个子女可以关联多个老人。

### Q: 密码可以重置吗？

A: 当前版本需要通过数据库直接修改，后续版本会添加密码重置功能。

## 版本信息

- **版本**：2.0.0
- **更新日期**：2026-08-26
- **兼容性**：不兼容1.x版本的API
