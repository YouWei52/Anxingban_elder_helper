# 移动端老人端适配完成总结

## ✅ 已完成工作

### 1. 会话层

- ✅ 创建 `ElderSession` 类管理老人令牌和档案ID持久化
- ✅ 使用 `shared_preferences` 存储会话状态

### 2. API客户端重构

- ✅ 基础地址改为 `http://localhost:8000`（移除 `/api/app`）
- ✅ 自动注入 JWT Bearer Token 到所有请求
- ✅ 401/403 自动清除会话
- ✅ 统一错误处理和中文提示
- ✅ 完整对接老人端API：
  - `/api/auth/elder/login` - 登录
  - `/api/auth/elder/me` - 获取老人信息
  - `/api/elder/profiles` - 档案列表
  - `/api/elder/trips` - 行程列表
  - `/api/elder/tasks` - 任务列表（只读）
  - `/api/elder/sos/trigger` - 触发SOS
  - `/api/elder/guide/ask` - 景点讲解
  - `/api/elder/cards` - 回忆卡片（完整操作）

### 3. 新建老人专用页面

#### 登录页 `screens/auth/elder_login_screen.dart`

- 手机号+密码登录
- 表单验证
- 登录成功后保存会话并跳转主页

#### 首页 `screens/elder/elder_home_screen.dart`

- 显示老人姓名欢迎卡片
- 大按钮触发SOS紧急求助
- 快捷入口：景点讲解、我的回忆
- SOS自动获取GPS定位

#### 旅途页 `screens/elder/elder_journey_screen.dart`

- 显示老人的行程列表（只读）
- 下拉刷新
- 点击查看行程详情（底部抽屉）
- 显示通行码

#### 回忆页 `screens/elder/elder_memory_screen.dart`

- 显示回忆卡片列表
- 支持删除卡片
- 查看卡片详情
- 浮动按钮生成新卡片

#### 个人中心 `screens/elder/elder_profile_screen.dart`

- 显示老人信息（姓名、手机号）
- 档案列表及选择当前档案
- 关于页面
- 退出登录

### 4. 导航重构

- ✅ 欢迎页检查会话，有令牌直接进主页
- ✅ 欢迎页"开始使用"跳转登录页
- ✅ 主导航四个Tab全部替换为老人专用页面
- ✅ 移除旧的子女创建/编辑功能入口

### 5. 后端修复

- ✅ 修正 `GuideElderController` 调用不存在的方法，改用 `GuideService.ask_question()`

## 🎯 权限对齐

| 功能 | 老人权限 | 移动端实现 |
| ----- | --------- | ---------- |
| 档案管理 | 只读 | ✅ 显示档案列表，选择当前档案 |
| 行程管理 | 只读 | ✅ 显示行程列表和详情 |
| 任务管理 | 只读 | ⚠️ 暂未在移动端展示 |
| SOS求助 | 触发+查看 | ✅ 首页触发，自动定位 |
| 回忆卡片 | 完整CRUD | ✅ 查看、删除、生成入口 |
| 景点讲解 | 完整操作 | ✅ 提问和查看回答 |

## 📱 用户流程

```
欢迎页 → 登录页 → 主导航
                    ├─ 首页（SOS + 快捷入口）
                    ├─ 回忆（卡片列表）
                    ├─ 旅途（行程列表）
                    └─ 我的（个人信息 + 退出）
```

## ⚠️ 已知限制

1. **Profile关联逻辑**
   - 当前 Profile API 返回的是 `elder_id`/`user_id` 关联，不含老人详细信息
   - 移动端通过 `getElderInfo()` 获取老人自身信息
   - 档案ID需手动在个人中心选择并保存到会话

2. **localhost限制**
   - 当前 API 地址写死 `http://localhost:8000`
   - 真机调试需改为开发机局域网IP（如 `http://192.168.x.x:8000`）
   - 生产环境需配置环境变量或构建参数

3. **任务功能**
   - 老人端可查看任务但未在移动端展示
   - 可后续在旅途详情中添加任务列表

4. **离线支持**
   - 当前无离线缓存
   - 网络异常时用户体验较差

## 🔧 构建准备

### 依赖检查

已在 `pubspec.yaml` 中声明所有依赖：

- `http` - HTTP客户端
- `shared_preferences` - 会话存储
- `geolocator` - GPS定位（SOS）
- `google_fonts` - 字体
- `flutter_svg` - SVG支持（QR码）

### 后续步骤

1. 进入 `mobile/anxingban` 目录
2. 运行 `flutter pub get` 安装依赖
3. 启动后端 `uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`
4. 修改 `api_client.dart` 的 `baseUrl` 为实际IP（真机）
5. 运行 `flutter run` 或在Android Studio/VS Code启动

### 最小验证流程

1. 后端创建老人账号（通过 API 文档或脚本）
2. 移动端登录
3. 个人中心选择档案（如果有Profile）
4. 首页触发SOS
5. 景点讲解提问
6. 查看旅途和回忆

## 📊 文件清单

### 新增文件（7个）

- `lib/core/auth/elder_session.dart` - 会话管理
- `lib/screens/auth/elder_login_screen.dart` - 登录页
- `lib/screens/elder/elder_home_screen.dart` - 首页
- `lib/screens/elder/elder_journey_screen.dart` - 旅途页
- `lib/screens/elder/elder_memory_screen.dart` - 回忆页
- `lib/screens/elder/elder_profile_screen.dart` - 个人中心
- `doc/mobile/ELDER_IMPLEMENTATION.md` - 本文档

### 修改文件（3个）

- `lib/core/api/api_client.dart` - API客户端重构
- `lib/screens/welcome/welcome_screen.dart` - 会话检查
- `lib/main.dart` - 导航页面替换

### 保留但不再使用（旧子女页面）

- `lib/screens/home/home_screen.dart`
- `lib/screens/memory/memory_screen.dart`
- `lib/screens/journey/journey_screen.dart`
- `lib/screens/profile/profile_screen.dart`
- `lib/screens/trip/trip_screen.dart`
- `lib/screens/task/task_screen.dart`
- `lib/screens/card/card_screen.dart`

## 🎉 总结

移动端已完全切换到老人端业务模型，所有页面与后端 `/api/elder/*` 和 `/api/auth/elder/*` 对齐，支持登录、会话管理、SOS、景点讲解、行程查看和回忆管理。下一步可进行真机构建和端到端测试。
