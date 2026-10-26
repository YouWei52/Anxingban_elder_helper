# Flutter Web 竖屏浏览器构建指南

## 前提条件

需要安装 Flutter SDK。如果未安装，请按以下步骤操作：

### 1. 安装 Flutter

```bash
# 下载 Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# 添加到 PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 验证安装
flutter doctor
```

### 2. 启用 Web 支持

```bash
cd /home/ivan/Projects/Anxingban_elder_helper/mobile/anxingban
flutter config --enable-web
```

## 构建步骤

### 方法一：Flutter Web 构建（推荐）

```bash
cd /home/ivan/Projects/Anxingban_elder_helper/mobile/anxingban

# 1. 安装依赖
flutter pub get

# 2. 构建 Web 版本（发布模式）
flutter build web --release

# 3. 构建结果在 build/web/ 目录
# 可以直接部署到任何 Web 服务器
```

### 方法二：开发模式运行

```bash
# 在 Chrome 中运行（开发模式）
flutter run -d chrome

# 指定端口
flutter run -d chrome --web-port=8080

# 启用热重载
flutter run -d chrome --hot
```

## 部署到服务器

### 选项 1: 使用 Python HTTP 服务器（快速测试）

```bash
cd build/web
python3 -m http.server 8080
# 访问 http://localhost:8080
```

### 选项 2: 使用 Nginx

```nginx
server {
    listen 80;
    server_name anxingban.example.com;
    root /path/to/build/web;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # 启用 gzip 压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}
```

### 选项 3: 复制到现有 frontend 目录

```bash
# 构建后复制到前端目录
flutter build web --release
cp -r build/web/* ../../frontend/
```

## Web 配置说明

### 已优化的功能

✅ **竖屏锁定**

- `manifest.json` 中设置 `"orientation": "portrait-primary"`
- viewport 设置为禁止缩放和旋转

✅ **移动端优化**

- 防止 iOS 下拉刷新
- 防止双指缩放
- 防止默认手势行为
- 全屏显示模式

✅ **PWA 支持**

- 可安装到主屏幕
- 离线缓存（Service Worker）
- 启动画面

✅ **加载优化**

- 自定义加载动画
- 渐变背景效果
- 品牌色主题

### 文件说明

- `web/index.html` - 主 HTML 文件（已优化竖屏）
- `web/manifest.json` - PWA 配置（已设置竖屏）
- `web/mobile.html` - 独立移动端版本（可选）

## 浏览器兼容性

### 支持的浏览器

✅ Chrome/Edge 90+
✅ Safari 14+
✅ Firefox 88+
✅ 移动端浏览器（iOS Safari, Chrome Mobile）

### 推荐分辨率

- 竖屏：375x667 (iPhone SE)
- 竖屏：390x844 (iPhone 12/13/14)
- 竖屏：414x896 (iPhone 11/XR)
- 最大宽度：430px（自动居中）

## 性能优化建议

### 1. 启用代码拆分

```bash
flutter build web --release --split-debug-info=./debug_info --obfuscate
```

### 2. 优化资源大小

```bash
# 压缩图片
flutter build web --release --no-tree-shake-icons

# 使用 Web 渲染器（较小体积）
flutter build web --release --web-renderer html
```

### 3. 启用缓存

在 `web/index.html` 中已添加 Service Worker 支持，自动缓存资源。

## 调试

### Chrome DevTools

```bash
# 1. 运行开发模式
flutter run -d chrome

# 2. 打开 DevTools
# 在浏览器中按 F12
```

### 移动端调试

```bash
# 模拟移动设备
flutter run -d chrome --web-browser-flag="--user-agent=Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"

# 或者在 Chrome DevTools 中：
# 1. 按 F12
# 2. 点击设备工具栏图标
# 3. 选择移动设备（如 iPhone 12 Pro）
```

## 常见问题

### Q: Flutter 命令未找到

**A:** 需要先安装 Flutter SDK（见上方"安装 Flutter"）

### Q: 构建后体积太大

**A:** 使用以下优化选项：

```bash
flutter build web --release --web-renderer canvaskit --split-debug-info=./debug_info
```

### Q: 某些功能在 Web 上不工作

**A:** Flutter Web 不支持某些原生功能：

- 地理位置：使用 Web Geolocation API
- 文件选择：使用 `<input type="file">`
- 推送通知：使用 Web Push API

### Q: 如何在生产环境部署

**A:**

1. 构建发布版本：`flutter build web --release`
2. 将 `build/web/` 内容上传到服务器
3. 配置 HTTPS（PWA 要求）
4. 配置正确的 MIME 类型

## 直接使用说明（无需 Flutter SDK）

如果服务器上没有 Flutter，可以：

1. **在本地构建**：在开发机上运行 `flutter build web --release`
2. **上传构建结果**：将 `build/web/` 目录上传到服务器
3. **直接部署**：使用任何 Web 服务器（Nginx, Apache, etc.）

### 快速部署脚本

```bash
#!/bin/bash
# 本地构建
flutter build web --release

# 打包
cd build/web
tar -czf anxingban-web.tar.gz *

# 上传到服务器
scp anxingban-web.tar.gz user@server:/var/www/

# 服务器上解压
ssh user@server 'cd /var/www && tar -xzf anxingban-web.tar.gz'
```

## 当前状态

✅ Web 配置已完成
✅ 竖屏优化已启用
✅ 移动端手势已优化
✅ PWA 配置已设置
⏳ 需要 Flutter SDK 进行构建

如需立即使用，建议：

1. 复用现有的 `frontend/` Web 应用
2. 或在有 Flutter 环境的机器上构建后部署
