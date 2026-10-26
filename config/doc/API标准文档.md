# 安行伴后端 API 文档

**基础地址**: `http://localhost:8000` (开发) / `http://47.237.188.77:8000` (生产)  
**接口总数**: 47 个  
**版本**: v2.0 (用户体系重构)  
**最后更新**: 2026-08-26

---

## 🔐 认证说明

**v2.0 重要变更**：所有API现在需要JWT认证（除了认证接口本身）

### 用户类型

系统支持两类用户：

1. **子女用户（User）** - 完整的系统管理权限
2. **老人用户（Elder）** - 受限的只读和部分操作权限

### JWT令牌

- **有效期**: 7天
- **使用方式**: 在HTTP Header中添加 `Authorization: Bearer <token>`
- **获取方式**: 通过登录接口获得

### 认证流程

```javascript
// 1. 注册或登录
const response = await fetch('http://localhost:8000/api/auth/user/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    phone: '13800138000',
    password: 'MyPass123!'
  })
});
const { access_token } = await response.json();

// 2. 使用令牌访问受保护的API
const profiles = await fetch('http://localhost:8000/api/user/profiles', {
  headers: {
    'Authorization': `Bearer ${access_token}`
  }
});
```

---

## 📖 快速开始

### 密码复杂度要求

注册时密码必须满足：

- 至少8个字符
- 包含至少一个大写字母
- 包含至少一个小写字母
- 包含至少一个数字
- 包含至少一个特殊字符

示例有效密码：`MyPass123!`

### 接口调用示例

```javascript
// 带认证的API调用
const response = await fetch('http://localhost:8000/api/user/profiles', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${access_token}`
  },
  body: JSON.stringify({
    elder_id: 1,
    user_id: 1
  })
});
const data = await response.json();
```

---

## 📚 接口列表

### 0. 认证管理 `/api/auth` 🆕

#### 0.1 子女用户注册

```
POST /api/auth/user/register
```

**请求体**:

```json
{
  "nickname": "张三",
  "phone": "13800138000",
  "password": "MyPass123!"
}
```

**响应示例**:

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "token_type": "bearer",
  "user_type": "user",
  "user_id": 1
}
```

#### 0.2 子女用户登录

```
POST /api/auth/user/login
```

**请求体**:

```json
{
  "phone": "13800138000",
  "password": "MyPass123!"
}
```

**响应**: 同注册响应

#### 0.3 获取当前子女用户信息

```
GET /api/auth/user/me
```

**请求头**: `Authorization: Bearer <token>`

**响应**:

```json
{
  "id": 1,
  "nickname": "张三",
  "phone": "13800138000",
  "last_login_at": "2026-08-26T10:00:00",
  "created_at": "2026-08-25T10:00:00"
}
```

#### 0.4 老人用户注册

```
POST /api/auth/elder/register
```

**请求体**:

```json
{
  "name": "李奶奶",
  "phone": "13900139000",
  "password": "ElderPass123!",
  "health_info": "{\"chronic_diseases\": \"高血压\", \"allergies\": \"无\"}",
  "interests": "文化,美食,历史",
  "wechat_webhook_url": ""
}
```

**响应**:

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "token_type": "bearer",
  "user_type": "elder",
  "user_id": 1
}
```

#### 0.5 老人用户登录

```
POST /api/auth/elder/login
```

**请求体**:

```json
{
  "phone": "13900139000",
  "password": "ElderPass123!"
}
```

#### 0.6 获取当前老人用户信息

```
GET /api/auth/elder/me
```

**请求头**: `Authorization: Bearer <token>`

**响应**:

```json
{
  "id": 1,
  "name": "李奶奶",
  "phone": "13900139000",
  "health_info": "{\"chronic_diseases\": \"高血压\"}",
  "interests": "文化,美食,历史",
  "wechat_webhook_url": "",
  "last_login_at": "2026-08-26T10:00:00",
  "created_at": "2026-08-25T10:00:00"
}
```

---

### 1. 档案管理

#### 子女用户API `/api/user/profiles` ✅ 完整权限

#### 1.1 获取档案列表

```
GET /api/user/profiles?limit=20
```

**请求头**: `Authorization: Bearer <token>`

**查询参数**:

- `limit` (int, 可选): 返回数量，默认 20，最大 100

**响应示例**:

```json
[
  {
    "id": 1,
    "elder_id": 1,
    "user_id": 1,
    "created_at": "2026-08-25T10:00:00"
  }
]
```

#### 1.2 创建档案关联

```
POST /api/user/profiles
```

**请求头**: `Authorization: Bearer <token>`

**请求体**:

```json
{
  "elder_id": 1,
  "user_id": 1
}
```

**响应**: 返回创建的档案对象 (201)

#### 1.3 获取档案详情

```
GET /api/user/profiles/{profile_id}
```

**请求头**: `Authorization: Bearer <token>`

**错误**: 404 - 档案不存在

#### 1.4 更新档案信息

```
PATCH /api/user/profiles/{profile_id}
PUT /api/user/profiles/{profile_id}
```

**请求头**: `Authorization: Bearer <token>`

#### 1.5 删除档案

```
DELETE /api/user/profiles/{profile_id}
```

**请求头**: `Authorization: Bearer <token>`

---

#### 老人用户API `/api/elder/profiles` ⚠️ 仅查看

#### 1.6 获取档案列表（老人）

```
GET /api/elder/profiles?limit=20
```

**请求头**: `Authorization: Bearer <elder_token>`

**权限**: 老人用户只能查看，不能创建、修改或删除

#### 1.7 获取档案详情（老人）

```
GET /api/elder/profiles/{profile_id}
```

**请求头**: `Authorization: Bearer <elder_token>`

---

### 2. 行程管理

#### 子女用户API `/api/user/trips` ✅ 完整权限

#### 2.1 创建行程

```
POST /api/user/trips
```

**请求头**: `Authorization: Bearer <token>`

**请求体**:

```json
{
  "profile_id": 1,
  "destination": "洪崖洞",
  "travel_date": "2026-08-26"
}
```

**响应**:

```json
{
  "id": 1,
  "profile_id": 1,
  "destination": "洪崖洞",
  "travel_date": "2026-08-26",
  "pass_token": "ELDER-abc123...",
  "pass_qr_svg": "<svg>...</svg>",
  "status": "created",
  "created_at": "2026-08-25T10:00:00"
}
```

#### 2.2 获取行程详情

```
GET /api/user/trips/{trip_id}
```

**请求头**: `Authorization: Bearer <token>`

#### 2.3 获取行程通行码

```
GET /api/user/trips/{trip_id}/pass
```

**请求头**: `Authorization: Bearer <token>`

#### 2.4 获取行程列表

```
GET /api/user/trips?profile_id=1&limit=100
```

**请求头**: `Authorization: Bearer <token>`

#### 2.5 删除行程

```
DELETE /api/user/trips/{trip_id}
```

**请求头**: `Authorization: Bearer <token>`

---

#### 老人用户API `/api/elder/trips` ⚠️ 仅查看

#### 2.6 获取行程列表（老人）

```
GET /api/elder/trips?profile_id=1&limit=20
```

**请求头**: `Authorization: Bearer <elder_token>`

**权限**: 老人用户只能查看行程，不能创建或删除

#### 2.7 获取行程详情（老人）

```
GET /api/elder/trips/{trip_id}
```

**请求头**: `Authorization: Bearer <elder_token>`

#### 2.8 获取行程通行码（老人）

```
GET /api/elder/trips/{trip_id}/pass
```

**请求头**: `Authorization: Bearer <elder_token>`

---

### 3. 亲子任务

#### 子女用户API `/api/user/tasks` ✅ 完整权限

#### 3.1 创建任务

```
POST /api/user/tasks
```

**请求头**: `Authorization: Bearer <token>`

**请求体**:

```json
{
  "profile_id": 1,
  "trip_id": 1,
  "title": "拍一张江景照片",
  "description": "在江边拍照并上传"
}
```

#### 3.2 完成任务

```
POST /api/user/tasks/{task_id}/complete
```

**请求头**: `Authorization: Bearer <token>`

**请求体**:

```json
{
  "completed_note": "已完成",
  "photo_url": "https://example.com/photo.jpg"
}
```

#### 3.3 任务反馈

```
POST /api/user/tasks/{task_id}/feedback
```

**请求头**: `Authorization: Bearer <token>`

**请求体**:

```json
{
  "feedback_text": "拍得真好！",
  "hearts_delta": 1
}
```

#### 3.4 获取任务列表

```
GET /api/user/tasks?profile_id=1&limit=20
```

**请求头**: `Authorization: Bearer <token>`

#### 3.5 删除任务

```
DELETE /api/user/tasks/{task_id}
```

**请求头**: `Authorization: Bearer <token>`

---

#### 老人用户API `/api/elder/tasks` ⚠️ 仅查看

#### 3.6 获取任务列表（老人）

```
GET /api/elder/tasks?profile_id=1&limit=20
```

**请求头**: `Authorization: Bearer <elder_token>`

**权限**: 老人用户只能查看任务，不能创建、完成、反馈或删除

#### 3.7 获取任务详情（老人）

```
GET /api/elder/tasks/{task_id}
```

**请求头**: `Authorization: Bearer <elder_token>`

---

### 4. 紧急求助

#### 子女用户API `/api/user/sos` ⚠️ 仅查看

**注意**: 子女用户只能查看SOS记录，不能触发SOS（触发功能仅限老人用户）

#### 4.1 获取 SOS 记录列表

```
GET /api/user/sos?profile_id=1&limit=100
```

**请求头**: `Authorization: Bearer <token>`

**权限**: 子女用户只能查看SOS记录

#### 4.2 获取指定档案的 SOS 历史

```
GET /api/user/sos/profile/{profile_id}
```

**请求头**: `Authorization: Bearer <token>`

---

#### 老人用户API `/api/elder/sos` ✅ 查看+触发

#### 4.3 触发紧急求助（老人）

```
POST /api/elder/sos/trigger
```

**请求头**: `Authorization: Bearer <elder_token>`

**权限**: 老人用户可以触发SOS和查看记录

#### 4.4 获取 SOS 记录列表（老人）

```
GET /api/elder/sos?profile_id=1&limit=100
```

**请求头**: `Authorization: Bearer <elder_token>`

---

### 5. 回忆卡片

请求体**:

```json
{
  "profile_id": 1,
  "trip_id": 1,
  "latitude": 29.56,
  "longitude": 106.55,
  "network_status": "online"
}
```

**功能**:

- 自动发送短信给子女
- 发送企业微信通知（如已配置）

**

#### 子女用户API `/api/user/cards` ✅ 完整权限

#### 5.1 生成回忆卡片

```
POST /api/user/cards/generate
```

**请求头**: `Authorization: Bearer <token>`

**请求体**:

```json
{
  "trip_id": 1
}
```

#### 5.2 获取卡片详情

```
GET /api/user/cards/{card_id}
```

**请求头**: `Authorization: Bearer <token>`

#### 5.3 获取卡片列表

```
GET /api/user/cards?profile_id=1&trip_id=1&limit=20
```

**请求头**: `Authorization: Bearer <token>`

#### 5.4 删除卡片

```
DELETE /api/user/cards/{card_id}
```

**请求头**: `Authorization: Bearer <token>`

---

#### 老人用户API `/api/elder/cards` ✅ 完整操作

#### 5.5 生成回忆卡片（老人）

```
POST /api/elder/cards/generate
```

**请求头**: `Authorization: Bearer <elder_token>`

**权限**: 老人用户拥有完整的回忆卡片操作权限

#### 5.6 获取卡片列表（老人）

```
**注意**: 景点讲解功能仅限老人用户使用

#### 老人用户API `/api/elder/guide` ✅ 完整操作

#### 6.1 景点智能问答（老人）

```

POST /api/elder/guide/ask

```

**请求头**: `Authorization: Bearer <elder_token>`

**请求体**:

```json
{
  "question": "洪崖洞有什么历史故事？"
}
```

**响应**:

```json
{
  "answer": "洪崖洞是重庆著名的吊脚楼建筑群...",
  "confidence": 0.95,
  "scope": "knowledge_limited"
}
``
  "answer": "洪崖洞是重庆著名的吊脚楼建筑群...",
  "confidence": 0.95,
  "scope": "knowledge_limited"
}
```

---

#### 老人用户API `/api/elder/guide` ✅ 完整操作

#### 6.2 景点智能问答（老人）

```
POST /api/elder/guide/ask
```

**请求头**: `Authorization: Bearer <elder_token>`

**权限**: 老人用户拥有完整的景点讲解功能

---

## 🔧 数据模型

### User（子女用户）🆕

```typescript
interface User {
  id: number;
  nickname: string;
  phone: string;
  password_hash: string;      // 仅存储，不返回
  last_login_at?: string;     // ISO 8601
  created_at: string;
}
```

### Elder（老人用户）🆕

```typescript
interface Elder {
  id: number;
  name: string;
  phone: string;
  password_hash: string;      // 仅存储，不返回
  health_info: string;        // JSON 字符串
  interests: string;          // 逗号分隔
  wechat_webhook_url?: string;
  last_login_at?: string;     // ISO 8601
  created_at: string;
}
```

### Profile（档案关联）🔄 已重构

```typescript
interface Profile {
  id: number;
  elder_id: number;           // 关联老人ID
  user_id: number;            // 关联子女ID
  created_at: string;         // ISO 8601
}
```

### Trip（行程）

```typescript
interface Trip {
  id: number;
  profile_id: number;
  destination: string;
  travel_date: string;       // YYYY-MM-DD
  pass_token: string;
  pass_qr_svg: string;       // SVG 字符串
  status: 'created' | 'completed';
  created_at: string;
}
```

### Task（任务）

```typescript
interface Task {
  id: number;
  profile_id: number;
  trip_id: number;
  title: string;
  description: string;
  status: 'pending' | 'completed';
  completed_note?: string;
  photo_url?: string;
  feedback_text?: string;
  hearts: number;
  created_at: string;
  completed_at?: string;
}
```

---

## 📊 权限矩阵

| 功能模块 | 子女用户 (`/api/user/*`) | 老人用户 (`/api/elder/*`) |
| --------- | ------------------------- | ------------------------- |
| 档案管理 | ✅ 完整CRUD | ⚠️ 仅查看 |
| 行程管理 | ✅ 完整CRUD | ⚠️ 仅查看 |
| 亲子任务 | ✅ 完整CRUD | ⚠️ 仅查看 |
| 紧急求助 | ✅ 完整操作 | ✅ 查看+触发 |
| 回忆卡片 | ✅ 完整CRUD | ✅ 完整操作 |
| 景点讲解 | ✅ 完整操作 | ✅ 完整操作 |

---

## ⚠️ 错误处理

所有接口统一错误响应格式：

```json
{
  "detail": "错误描述信息"
}
```

**常见错误码**:

- `401 Unauthorized` - 未认证或令牌无效/过期
- `403 Forbidden` - 权限不足
- `404 Not Found` - 资源不存在
- `422 Unprocessable Entity` - 请求参数验证失败
- `500 Internal Server Error` - 服务器内部错误

**认证错误示例**:

```javascript
try {
  const response = await fetch('/api/user/profiles', {
    headers: {
      'Authorization': 'Bearer invalid_token'
    }
  });
  if (response.status === 401) {
    console.error('令牌无效或已过期，请重新登录');
    // 跳转到登录页面
  }
} catch (err) {
  console.error('网络错误:', err);
}
```

---

## 📋 典型业务流程

### 完整出游流程（v2.0）

```javascript
// 1. 子女用户登录
const loginResponse = await fetch('/api/auth/user/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    phone: '13800138000',
    password: 'MyPass123!'
  })
});
const { access_token } = await loginResponse.json();

// 2. 创建档案关联（假设elder_id和user_id已知）
const profile = await fetch('/api/user/profiles', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${access_token}`
  },
  body: JSON.stringify({
    elder_id: 1,
    user_id: 1
  })
}).then(r => r.json());

// 3. 创建行程
const trip = await fetch('/api/user/trips', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${access_token}`
  },
  body: JSON.stringify({
    profile_id: profile.id,
    destination: "洪崖洞",
    travel_date: "2026-08-26"
  })
}).then(r => r.json());

// 4. 创建任务
const task = await fetch('/api/user/tasks', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${access_token}`
  },
  body: JSON.stringify({
    profile_id: profile.id,
    trip_id: trip.id,
    title: "拍照打卡",
    description: "在江边拍照"
  })
}).then(r => r.json());

// 5. 完成任务
await fetch(`/api/user/tasks/${task.id}/complete`, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${access_token}`
  },
  body: JSON.stringify({
    completed_note: "已完成",
    photo_url: "https://..."
  })
});

// 6. 生成回忆卡片
await fetch('/api/user/cards/generate', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${access_token}`
  },
  body: JSON.stringify({
    trip_id: trip.id
  })
});
```

---

## 📱 前端集成建议

### API 封装示例（v2.0）

```javascript
// api/client.js
const BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

class APIClient {
  constructor() {
    this.token = null;
  }

  setToken(token) {
    this.token = token;
    // 保存到localStorage
    if (token) {
      localStorage.setItem('access_token', token);
    } else {
      localStorage.removeItem('access_token');
    }
  }

  getToken() {
    if (!this.token) {
      this.token = localStorage.getItem('access_token');
    }
    return this.token;
  }

  async request(endpoint, options = {}) {
    const url = `${BASE_URL}${endpoint}`;
    const config = {
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    };

    // 添加认证令牌
    const token = this.getToken();
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    
    const response = await fetch(url, config);
    
    // 处理401错误（令牌过期）
    if (response.status === 401) {
      this.setToken(null);
      // 触发登录页面跳转
      window.location.href = '/login';
      throw new Error('令牌已过期，请重新登录');
    }

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.detail || '请求失败');
    }
    
    return response.json();
  }

  // 认证API
  auth = {
    // 子女用户
    userRegister: (data) => this.request('/api/auth/user/register', {
      method: 'POST',
      body: JSON.stringify(data)
    }),
    userLogin: async (data) => {
      const result = await this.request('/api/auth/user/login', {
        method: 'POST',
        body: JSON.stringify(data)
      });
      this.setToken(result.access_token);
      return result;
    },
    getUserInfo: () => this.request('/api/auth/user/me'),

    // 老人用户
    elderRegister: (data) => this.request('/api/auth/elder/register', {
      method: 'POST',
      body: JSON.stringify(data)
    }),
    elderLogin: async (data) => {
      const result = await this.request('/api/auth/elder/login', {
        method: 'POST',
        body: JSON.stringify(data)
      });
      this.setToken(result.access_token);
      return result;
    },
    getElderInfo: () => this.request('/api/auth/elder/me'),

    // 登出
    logout: () => {
      this.setToken(null);
    }
  };
  
  // 子女用户API
  user = {
    profiles: {
      list: (limit = 20) => this.request(`/api/user/profiles?limit=${limit}`),
      create: (data) => this.request('/api/user/profiles', {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      get: (id) => this.request(`/api/user/profiles/${id}`),
      update: (id, data) => this.request(`/api/user/profiles/${id}`, {
        method: 'PATCH',
        body: JSON.stringify(data)
      }),
      delete: (id) => this.request(`/api/user/profiles/${id}`, {
        method: 'DELETE'
      })
    },
    
    trips: {
      create: (data) => this.request('/api/user/trips', {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      get: (id) => this.request(`/api/user/trips/${id}`),
      getPass: (id) => this.request(`/api/user/trips/${id}/pass`),
      list: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/user/trips?${query}`);
      },
      delete: (id) => this.request(`/api/user/trips/${id}`, {
        method: 'DELETE'
      })
    },

    tasks: {
      create: (data) => this.request('/api/user/tasks', {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      complete: (id, data) => this.request(`/api/user/tasks/${id}/complete`, {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      feedback: (id, data) => this.request(`/api/user/tasks/${id}/feedback`, {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      list: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/user/tasks?${query}`);
      },
      delete: (id) => this.request(`/api/user/tasks/${id}`, {
        method: 'DELETE'
      })
    },
    
    sos: {
      trigger: (data) => this.request('/api/user/sos/trigger', {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      list: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/user/sos?${query}`);
      }
    },

    calist: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/user/sos?${query}`);
      },
      listByProfile: (profileId) => this.request(`/api/user/sos/profile/${profileId}`) const query = new URLSearchParams(params).toString();
        return this.request(`/api/user/cards?${query}`);
      },
      delete: (id) => this.request(`/api/user/cards/${id}`, {
        method: 'DELETE'
      })
    },

    guide: {
      ask: (question) => this.request('/api/user/guide/ask', {
        method: 'POST',
        body: JSON.stringify({ question })
      })
    }
  };

  // 老人用户API
  elder = {
    profiles: {
      list: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/elder/trips?${query}`);
      }
    },

    tasks: {
      get: (id) => this.request(`/api/elder/tasks/${id}`),
      list: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/elder/tasks?${query}`);
      }
    },

    sos: {
      trigger: (data) => this.request('/api/elder/sos/trigger', {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      list: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/elder/sos?${query}`);
      }
    },

    cards: {
      generate: (data) => this.request('/api/elder/cards/generate', {
        method: 'POST',
        body: JSON.stringify(data)
      }),
      get: (id) => this.request(`/api/elder/cards/${id}`),
      list: (params = {}) => {
        const query = new URLSearchParams(params).toString();
        return this.request(`/api/elder/cards?${query}`);
      },
      delete: (id) => this.request(`/api/elder/cards/${id}`, {
        method: 'DELETE'
      })
    },

    guide: {
      ask: (question) => this.request('/api/elder/guide/ask', {
        method: 'POST',
        body: JSON.stringify({ question })
      })
    }
  };
}

export const api = new APIClient();
```

### 使用示例

```javascript
import { api } from './api/client';

// 子女用户登录
try {
  const result = await api.auth.userLogin({
    phone: '13800138000',
    password: 'MyPass123!'
  });
  console.log('登录成功:', result);
  
  // 获取用户信息
  const userInfo = await api.auth.getUserInfo();
  console.log('用户信息:', userInfo);
  
  // 创建档案
  const profile = await api.user.profiles.create({
    elder_id: 1,
    user_id: userInfo.id
  });
  console.log('档案创建成功:', profile);
} catch (err) {
  console.error('操作失败:', err.message);
}

// 老人用户登录
try {
  const result = await api.auth.elderLogin({
    phone: '13900139000',
    password: 'ElderPass123!'
  });
  
  // 触发SOS
  await api.elder.sos.trigger({
    profile_id: 1,
    trip_id: 1,
    latitude: 29.56,
    longitude: 106.55,
    network_status: 'online'
  });
} catch (err) {
  console.error('操作失败:', err.message);
}

// 登出
api.auth.logout();
```

---

## 🧪 在线测试

### Swagger UI

访问 `http://localhost:8000/docs` 可以：

- 查看完整接口文档
- 在线测试所有接口（支持JWT认证）
- 查看请求/响应示例

### 认证测试

1. 访问 `/docs`
2. 点击页面右上角的 "Authorize" 按钮
3. 输入JWT令牌（格式：`Bearer <token>`）
4. 测试需要认证的接口

### OpenAPI 定义

访问 `http://localhost:8000/openapi.json` 获取 OpenAPI 3.0 规范，可导入到：

- Postman
- Apifox
- Insomnia

---

## 🚀 环境配置

### 开发环境 (.env.development)

```env
VITE_API_BASE_URL=http://localhost:8000
```

### 生产环境 (.env.production)

```env
VITE_API_BASE_URL=http://服务器IP:8000
```

### 后端配置 (.env)

```env
SECRET_KEY=your-secret-key-change-in-production-jwt-signing
DATABASE_URL=mysql+pymysql://user:password@localhost:3306/anbanx
```

---

## 🔄 迁移指南（v1.0 → v2.0）

### 主要变更

1. **认证机制**: 所有API现在需要JWT令牌
2. **API路径**: 从 `/api/app/*` 改为 `/api/user/*` 和 `/api/elder/*`
3. **数据库结构**: Profile表重构为关联表
4. **用户系统**: 新增User和Elder表

### 迁移步骤

1. **注册用户账号**

   ```javascript
   // 为现有用户创建账号
   await api.auth.userRegister({
     nickname: "张三",
     phone: "13800138000",
     password: "MyPass123!"
   });
   ```

2. **更新API调用**

   ```javascript
   // 旧版本（v1.0）
   fetch('/api/app/profiles')
   
   // 新版本（v2.0）
   fetch('/api/user/profiles', {
     headers: {
       'Authorization': `Bearer ${token}`
     }
   })
   ```

3. **执行数据库迁移**

   ```bash
   mysql -u root -p < db/DDL_new.sql
   ```

---

## 📖 相关文档

- [用户体系说明文档](../docs/USER_SYSTEM.md)
- [实现总结](../IMPLEMENTATION_SUMMARY.md)
- [数据库DDL](../db/DDL_new.sql)

---

**文档维护**: 后端团队  
**版本历史**:

- v2.0 (2026-08-26): 用户体系重构，新增JWT认证
- v1.0 (2026-08-25): 初始版本

**联系方式**: 通过 Swagger UI 查看详细文档

---

## 📚 接口列表

### 1. 档案管理 `/api/profiles`

#### 1.1 获取档案列表

```
GET /api/profiles?limit=20
```

**查询参数**:

- `limit` (int, 可选): 返回数量，默认 20，最大 100

**响应示例**:

```json
[
  {
    "id": 1,
    "parent_name": "张三",
    "parent_phone": "13800000000",
    "child_name": "张小明",
    "child_phone": "13900000000",
    "health_info": "{\"chronic_diseases\":\"高血压\"}",
    "interests": "文化,美食",
    "created_at": "2026-08-25T10:00:00"
  }
]
```

#### 1.2 创建家庭档案

```
POST /api/profiles
```

**请求体**:

```json
{
  "parent_name": "张三",
  "parent_phone": "13800000000",
  "child_name": "张小明",
  "child_phone": "13900000000",
  "chronic_diseases": "高血压",
  "allergies": "无",
  "mobility_limitations": "轻度",
  "interests": "文化,美食,历史",
  "wechat_webhook_url": ""
}
```

**响应**: 返回创建的档案对象 (201)

#### 1.3 获取档案详情

```
GET /api/profiles/{profile_id}
```

**路径参数**:

- `profile_id` (int): 档案 ID

**错误**: 404 - 档案不存在

#### 1.4 更新档案信息

```
PATCH /api/profiles/{profile_id}
```

**请求体** (部分更新):

```json
{
  "parent_phone": "13800000001",
  "interests": "文化,美食,历史,艺术"
}
```

**错误**: 404 - 档案不存在

---

### 2. 行程管理 `/api/trips`

#### 2.1 创建行程

```
POST /api/trips
```

**请求体**:

```json
{
  "profile_id": 1,
  "destination": "洪崖洞",
  "travel_date": "2026-08-26"
}
```

**响应**:

```json
{
  "id": 1,
  "profile_id": 1,
  "destination": "洪崖洞",
  "travel_date": "2026-08-26",
  "pass_token": "ELDER-abc123...",
  "pass_qr_svg": "<svg>...</svg>",
  "status": "created",
  "created_at": "2026-08-25T10:00:00"
}
```

#### 2.2 获取行程详情

```
GET /api/trips/{trip_id}
```

**错误**: 404 - 行程不存在

#### 2.3 获取行程通行码

```
GET /api/trips/{trip_id}/pass
```

**响应**:

```json
{
  "pass_token": "ELDER-abc123...",
  "pass_qr_svg": "<svg>...</svg>",
  "destination": "洪崖洞",
  "travel_date": "2026-08-26"
}
```

#### 2.4 获取档案行程列表

```
GET /api/trips/profile/{profile_id}
```

---

### 3. 亲子任务 `/api/tasks`

#### 3.1 创建任务

```
POST /api/tasks
```

**请求体**:

```json
{
  "profile_id": 1,
  "trip_id": 1,
  "title": "拍一张江景照片",
  "description": "在江边拍照并上传"
}
```

#### 3.2 完成任务

```
POST /api/tasks/{task_id}/complete
```

**请求体**:

```json
{
  "completed_note": "已完成",
  "photo_url": "https://example.com/photo.jpg"
}
```

**错误**: 404 - 任务不存在

#### 3.3 任务反馈

```
POST /api/tasks/{task_id}/feedback
```

**请求体**:

```json
{
  "feedback_text": "拍得真好！",
  "hearts": 1
}
```

#### 3.4 获取档案任务列表

```
GET /api/tasks/profile/{profile_id}
```

---

### 4. 紧急求助 `/api/sos`

#### 4.1 触发紧急求助

```
POST /api/sos/trigger
```

**请求体**:

```json
{
  "profile_id": 1,
  "trip_id": 1,
  "latitude": 29.56,
  "longitude": 106.55,
  "network_status": "online"
}
```

**功能**:

- 自动发送短信给子女
- 发送企业微信通知（如已配置）

**响应**:

```json
{
  "id": 1,
  "profile_id": 1,
  "sms_status": "sent:mock",
  "wechat_status": "not_configured",
  "created_at": "2026-08-25T10:00:00"
}
```

#### 4.2 获取 SOS 历史

```
GET /api/sos/profile/{profile_id}
```

---

### 5. 回忆卡片 `/api/cards`

#### 5.1 生成回忆卡片

```
POST /api/cards/generate
```

**请求体**:

```json
{
  "trip_id": 1,
  "title": "洪崖洞之旅",
  "summary": "今天游览了美丽的洪崖洞...",
  "image_url": "https://example.com/photo.jpg"
}
```

**错误**: 404 - 行程不存在

#### 5.2 获取卡片详情

```
GET /api/cards/{card_id}
```

**错误**: 404 - 卡片不存在

#### 5.3 获取行程卡片列表

```
GET /api/cards/trip/{trip_id}
```

---

### 6. 景点讲解 `/api/guide`

#### 6.1 景点智能问答

```
POST /api/guide/ask
```

**请求体**:

```json
{
  "question": "洪崖洞有什么历史故事？"
}
```

**响应**:

```json
{
  "answer": "洪崖洞是重庆著名的吊脚楼建筑群...",
  "confidence": 0.95
}
```

---

## 🔧 数据模型

### Profile（档案）

```typescript
interface Profile {
  id: number;
  parent_name: string;
  parent_phone: string;
  child_name: string;
  child_phone: string;
  health_info: string;       // JSON 字符串
  interests: string;         // 逗号分隔
  wechat_webhook_url?: string;
  created_at: string;        // ISO 8601
}
```

### Trip（行程）

```typescript
interface Trip {
  id: number;
  profile_id: number;
  destination: string;
  travel_date: string;       // YYYY-MM-DD
  pass_token: string;
  pass_qr_svg: string;       // SVG 字符串
  status: 'created' | 'completed';
  created_at: string;
}
```

### Task（任务）

```typescript
interface Task {
  id: number;
  profile_id: number;
  trip_id: number;
  title: string;
  description: string;
  status: 'pending' | 'completed';
  completed_note?: string;
  photo_url?: string;
  feedback_text?: string;
  hearts: number;
  created_at: string;
  completed_at?: string;
}
```

---

## ⚠️ 错误处理

所有接口统一错误响应格式：

```json
{
  "detail": "错误描述信息"
}
```

**常见错误码**:

- `404 Not Found` - 资源不存在
- `422 Unprocessable Entity` - 请求参数验证失败
- `500 Internal Server Error` - 服务器内部错误

**示例**:

```javascript
try {
  const response = await fetch('/api/profiles/999');
  if (!response.ok) {
    const error = await response.json();
    console.error('错误:', error.detail);  // "档案不存在"
  }
} catch (err) {
  console.error('网络错误:', err);
}
```

---

## 📋 典型业务流程

### 完整出游流程

```javascript
// 1. 创建档案
const profile = await fetch('/api/profiles', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({...})
}).then(r => r.json());

// 2. 创建行程
const trip = await fetch('/api/trips', {
  method: 'POST',
  body: JSON.stringify({
    profile_id: profile.id,
    destination: "洪崖洞",
    travel_date: "2026-08-26"
  })
}).then(r => r.json());

// 3. 创建任务
const task = await fetch('/api/tasks', {
  method: 'POST',
  body: JSON.stringify({
    profile_id: profile.id,
    trip_id: trip.id,
    title: "拍照打卡"
  })
}).then(r => r.json());

// 4. 完成任务
await fetch(`/api/tasks/${task.id}/complete`, {
  method: 'POST',
  body: JSON.stringify({
    completed_note: "已完成",
    photo_url: "https://..."
  })
});

// 5. 生成回忆卡片
await fetch('/api/cards/generate', {
  method: 'POST',
  body: JSON.stringify({
    trip_id: trip.id,
    title: "美好回忆",
    summary: "今天很开心..."
  })
});
```

---

## 📱 前端集成建议

### API 封装示例

```javascript
// api/client.js
const BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000';

async function request(endpoint, options = {}) {
  const url = `${BASE_URL}${endpoint}`;
  const config = {
    headers: { 'Content-Type': 'application/json' },
    ...options
  };
  
  const response = await fetch(url, config);
  
  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.detail || '请求失败');
  }
  
  return response.json();
}

export const api = {
  // 档案
  profiles: {
    list: (limit = 20) => request(`/api/profiles?limit=${limit}`),
    create: (data) => request('/api/profiles', { method: 'POST', body: JSON.stringify(data) }),
    get: (id) => request(`/api/profiles/${id}`),
    update: (id, data) => request(`/api/profiles/${id}`, { method: 'PATCH', body: JSON.stringify(data) })
  },
  
  // 行程
  trips: {
    create: (data) => request('/api/trips', { method: 'POST', body: JSON.stringify(data) }),
    get: (id) => request(`/api/trips/${id}`),
    getPass: (id) => request(`/api/trips/${id}/pass`),
    listByProfile: (profileId) => request(`/api/trips/profile/${profileId}`)
  },
  
  // SOS
  sos: {
    trigger: (data) => request('/api/sos/trigger', { method: 'POST', body: JSON.stringify(data) }),
    listByProfile: (profileId) => request(`/api/sos/profile/${profileId}`)
  }
};
```

### 使用示例

```javascript
import { api } from './api/client';

// 创建档案
try {
  const profile = await api.profiles.create({
    parent_name: '张三',
    parent_phone: '13800000000',
    child_name: '张小明',
    child_phone: '13900000000',
    chronic_diseases: '高血压',
    allergies: '无',
    mobility_limitations: '轻度',
    interests: '文化,美食'
  });
  console.log('档案创建成功:', profile);
} catch (err) {
  console.error('创建失败:', err.message);
}
```

---

## 🧪 在线测试

### Swagger UI

访问 `http://localhost:8000/docs` 可以：

- 查看完整接口文档
- 在线测试所有接口
- 查看请求/响应示例

### OpenAPI 定义

访问 `http://localhost:8000/openapi.json` 获取 OpenAPI 3.0 规范，可导入到：

- Postman
- Apifox
- Insomnia

---

## 🚀 环境配置

### 开发环境 (.env.development)

```env
VITE_API_BASE_URL=http://localhost:8000
```

### 生产环境 (.env.production)

```env
VITE_API_BASE_URL=http://服务器IP:8000
```

---

**文档维护**: 后端团队  
**联系方式**: 通过 Swagger UI 查看详细文档
