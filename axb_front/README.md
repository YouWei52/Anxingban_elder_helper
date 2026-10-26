# 安行伴前端 - React版本

这是安行伴应用的React重构版本，与后端API完全兼容。

## 功能模块

1. **家庭建档** - 创建和管理家庭成员档案
2. **创建行程** - 定制旅行计划并生成通行证
3. **紧急求助** - 一键SOS功能，通知紧急联系人
4. **亲子任务** - 创建和管理旅行中的互动任务
5. **景点讲解** - AI智能导游问答
6. **回忆卡片** - 生成旅行回忆卡片
7. **景区推荐** - 重庆景区浏览和详情

## 技术栈

- **React 18** - UI框架
- **Vite** - 构建工具
- **原生CSS** - 保持与原版一致的样式

## 安装和运行

### 安装依赖

```bash
cd frontend
npm install
```

### 开发模式

```bash
npm run dev
```

应用将运行在 <http://localhost:3000>

### 构建生产版本

```bash
npm run build
```

构建产物将生成在 `dist/` 目录。

## API配置

前端通过Vite代理连接后端API：

- 开发环境：`http://127.0.0.1:8000`
- API路径：`/api/*`

确保后端服务已启动：

```bash
# 在项目根目录
uvicorn app.main:app --host 127.0.0.1 --port 8000 --reload
```

## 项目结构

```
frontend/
├── public/              # 静态资源
│   ├── poster/         # 景区图片
│   ├── cover-photo.jpg # 欢迎页背景
│   └── tropical-bg.svg # 背景装饰
├── src/
│   ├── api/            # API客户端
│   ├── components/     # React组件
│   │   ├── views/     # 视图组件
│   │   ├── Header.jsx
│   │   ├── Toast.jsx
│   │   └── ...
│   ├── hooks/          # React Hooks
│   ├── App.jsx         # 主应用
│   ├── App.css         # 样式（与原版一致）
│   └── main.jsx        # 入口文件
├── index.html
├── package.json
└── vite.config.js
```

## 与原版的区别

- ✅ 使用相同的API端点
- ✅ 保持完全一致的样式和设计
- ✅ 所有功能都已实现
- ✅ 响应式设计保持不变
- ⚠️  不包含 `/` 根路径（原版的静态首页），仅处理React应用路由

## 开发说明

- 组件采用函数式组件和Hooks
- 状态管理使用React内置的useState
- Toast通知使用Context API
- 路由通过状态管理实现（保持与原版一致的hash路由）
