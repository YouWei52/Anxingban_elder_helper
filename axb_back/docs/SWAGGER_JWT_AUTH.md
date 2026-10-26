# Swagger UI JWT认证配置说明

## 已完成的配置

### 1. 创建OpenAPI配置文件
- 文件：`../app/openapi_config.py`
- 功能：定义JWT Bearer认证方案

### 2. 集成到FastAPI应用
- 在 `../app/main.py` 中应用自定义OpenAPI Schema
- 所有需要认证的路由自动标记

### 3. Swagger UI功能
- ✅ 显示"Authorize"按钮（🔓图标）
- ✅ 用户可以输入JWT Token
- ✅ Token自动添加到所有请求的Header中
- ✅ 暗色主题已保留

---

## 使用方式

### 步骤1：注册或登录获取Token

在Swagger UI中：

1. 展开 **认证** 标签
2. 找到 `POST /api/auth/user/register` 或 `POST /api/auth/user/login`
3. 点击"Try it out"
4. 输入用户信息：
```json
{
  "nickname": "测试用户",
  "phone": "13800138000",
  "password": "password123"
}
```
5. 点击"Execute"
6. 从响应中复制 `access_token`

### 步骤2：配置认证

1. 点击页面右上角的 **🔓 Authorize** 按钮
2. 在弹出的对话框中输入Token：
   ```
   <粘贴你的access_token>
   ```
   **注意**：只需要输入token本身，不需要添加"Bearer "前缀
3. 点击"Authorize"
4. 点击"Close"关闭对话框

### 步骤3：测试受保护的API

现在所有请求会自动携带Token：
```
Authorization: Bearer <your_token>
```

例如测试获取档案列表：
1. 展开 `GET /api/user/profiles`
2. 点击"Try it out"
3. 点击"Execute"
4. 如果Token有效，返回200和数据
5. 如果Token无效，返回401或403

---

## 认证流程图

```
1. 用户注册/登录
   POST /api/auth/user/register
   ↓
   返回: { "access_token": "eyJ..." }

2. 点击Authorize按钮
   输入token
   ↓
   Swagger UI保存token

3. 访问受保护的API
   GET /api/user/profiles
   ↓
   Swagger UI自动添加Header:
   Authorization: Bearer eyJ...
   ↓
   后端验证token
   ↓
   返回数据或403错误
```

---

## 测试不同角色

### 测试普通用户权限
```json
// 登录为普通用户
POST /api/auth/user/login
{
  "phone": "13800138000",
  "password": "password123"
}

// 获取token后，尝试访问：
GET /api/user/profiles/{profile_id}
// ✅ 可以访问自己创建的档案
// ❌ 不能访问其他用户的档案（403）
```

### 测试管理员权限
```sql
-- 首先在数据库中创建管理员
UPDATE users SET role='admin' WHERE id=1;
```

```json
// 登录为管理员
POST /api/auth/user/login
{
  "phone": "admin_phone",
  "password": "admin_password"
}

// 获取token后，尝试访问：
GET /api/user/profiles/{any_profile_id}
// ✅ 可以访问所有档案
```

### 测试老人用户权限
```json
// 登录为老人
POST /api/auth/elder/login
{
  "phone": "13900139000",
  "password": "password123"
}

// 获取token后，尝试访问：
GET /api/elder/profiles
// ✅ 可以查看关联自己的档案
// ❌ 不能编辑档案（403）
```

---

## 常见问题

### Q1: 点击Execute后返回401 Unauthorized
**原因**：Token未配置或已过期

**解决**：
1. 确认已点击"Authorize"按钮
2. 检查Token是否正确粘贴
3. Token有效期默认7天，过期需重新登录

### Q2: 返回403 Forbidden
**原因**：有Token但无权限

**解决**：
- 检查访问的资源是否属于当前用户
- 确认用户角色是否正确
- 查看接口文档中的"权限要求"说明

### Q3: Authorize按钮不显示
**原因**：OpenAPI Schema未正确配置

**解决**：
1. 重启服务
2. 清除浏览器缓存
3. 检查 `app.openapi` 是否正确设置

### Q4: 如何退出登录？
**方法**：
1. 点击"Authorize"按钮
2. 点击"Logout"
3. 或直接清空Token输入框

---

## Swagger UI界面说明

### Authorize按钮位置
```
┌─────────────────────────────────────┐
│  anxingban API Documentation        │
│                          🔓 Authorize│  ← 点击这里
├─────────────────────────────────────┤
│  认证                                │
│  ▼ POST /api/auth/user/register     │
│  ▼ POST /api/auth/user/login        │
│                                      │
│  子女-档案管理                        │
│  🔒 GET /api/user/profiles          │  ← 有锁图标表示需要认证
└─────────────────────────────────────┘
```

### 认证对话框
```
┌────────── Available authorizations ──────────┐
│                                              │
│  BearerAuth (http, Bearer)                  │
│  输入JWT Token（从/api/auth/user/login获取）  │
│                                              │
│  Value: [________________________]           │
│         ↑ 粘贴token到这里                     │
│                                              │
│  [ Authorize ]  [ Close ]                   │
└──────────────────────────────────────────────┘
```

---

## 安全建议

### 开发环境
- ✅ 可以使用简单密码测试
- ✅ Token有效期可以设置较长
- ✅ 允许CORS: *

### 生产环境
- ⚠️ 使用强密码
- ⚠️ Token有效期建议1-24小时
- ⚠️ 限制CORS到具体域名
- ⚠️ 启用HTTPS
- ⚠️ 考虑添加Refresh Token机制

---

## 进阶功能

### 同时测试多个用户
Swagger UI只能保存一个Token，如果需要测试多个用户：

**方法1**：使用无痕窗口
- 普通窗口：登录用户A
- 无痕窗口：登录用户B

**方法2**：使用不同浏览器
- Chrome：登录用户A
- Firefox：登录用户B

**方法3**：使用Postman
- 支持保存多个环境
- 可以快速切换用户Token

### 自动刷新Token
当前配置下Token过期需要手动重新登录。

如需自动刷新：
1. 实现Refresh Token机制
2. 监听401响应
3. 自动调用刷新接口
4. 更新Swagger UI的Token

---

## 总结

现在Swagger UI已完全支持JWT认证测试：
- ✅ 暗色主题
- ✅ JWT认证按钮
- ✅ 自动添加Authorization Header
- ✅ 支持测试不同角色权限
- ✅ 清晰的权限错误提示

可以开始进行完整的黑盒测试了！
