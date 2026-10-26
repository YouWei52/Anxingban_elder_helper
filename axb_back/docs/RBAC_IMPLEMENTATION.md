# Profile模块RBAC改造说明

## 已完成的工作

### 1. 数据库准备
- ✅ 创建迁移脚本：`../db/migration_add_role.sql`
- ✅ 为 `users` 表添加 `role` 字段（默认值：'user'）
- ✅ 为 `elders` 表添加 `role` 字段（默认值：'elder'）

### 2. Entity扩展
- ✅ `UserEntity` 添加 `role` 字段
- ✅ `ElderEntity` 添加 `role` 字段
- ✅ `ProfileEntity` 添加 `__acl__()` 方法，定义权限规则

### 3. 权限系统配置
- ✅ 创建 `../app/modules/auth/permissions.py`
- ✅ 实现 `get_active_principals()` 函数
- ✅ 配置 `Permission` 依赖函数

### 4. Controller改造
- ✅ `ProfileController` 添加权限检查
- ✅ 创建 `get_profile_or_404()` 依赖函数
- ✅ 为 GET/PUT/PATCH/DELETE 路由添加 `Permission` 检查

### 5. 依赖更新
- ✅ `../requirements.txt` 添加 `fastapi-permissions==0.2.7`

---

## 权限规则

### ProfileEntity 权限定义

```python
def __acl__(self):
    return [
        (Allow, f"user:{self.user_id}", "view"),     # 创建者可查看
        (Allow, f"user:{self.user_id}", "edit"),     # 创建者可编辑
        (Allow, f"user:{self.user_id}", "delete"),   # 创建者可删除
        (Allow, f"elder:{self.elder_id}", "view"),   # 关联老人可查看
        (Allow, "role:admin", "view"),               # 管理员可查看
        (Allow, "role:admin", "edit"),               # 管理员可编辑
        (Allow, "role:admin", "delete"),             # 管理员可删除
    ]
```

### 用户身份标识（Principals）

**普通子女用户**：
```python
[Everyone, Authenticated, "user:123", "role:user"]
```

**普通老人用户**：
```python
[Everyone, Authenticated, "elder:456", "role:elder"]
```

**管理员**：
```python
[Everyone, Authenticated, "user:1", "role:admin"]
```

---

## 使用方式

### 1. 执行数据库迁移

```bash
# 连接数据库并执行迁移
mysql -u ivan -p123456 anxingban < db/migration_add_role.sql

# 验证字段已添加
mysql -u ivan -p123456 anxingban -e "DESCRIBE users;"
mysql -u ivan -p123456 anxingban -e "DESCRIBE elders;"
```

### 2. 安装依赖（Docker环境会自动安装）

```bash
pip install -r requirements.txt
```

### 3. 测试权限

#### 场景1：创建者访问自己的档案
```bash
# 用户123创建的档案，用户123访问 → ✅ 成功
curl -H "Authorization: Bearer <user_123_token>" \
  http://localhost:8000/api/user/profiles/1
```

#### 场景2：非创建者访问他人档案
```bash
# 用户123创建的档案，用户456访问 → ❌ 403 Forbidden
curl -H "Authorization: Bearer <user_456_token>" \
  http://localhost:8000/api/user/profiles/1
```

#### 场景3：管理员访问任意档案
```bash
# 管理员访问任意档案 → ✅ 成功
curl -H "Authorization: Bearer <admin_token>" \
  http://localhost:8000/api/user/profiles/1
```

#### 场景4：老人查看关联的档案
```bash
# 档案关联的老人查看 → ✅ 成功（仅查看，不可编辑）
curl -H "Authorization: Bearer <elder_456_token>" \
  http://localhost:8000/api/elder/profiles/1
```

---

## 工作流程图

```
用户请求 GET /api/user/profiles/1
    ↓
FastAPI 依赖注入系统执行：
    ↓
1. get_current_user() → 获取当前用户（user_id=123）
    ↓
2. get_profile_or_404(profile_id=1) → 获取档案资源
    ↓
3. Permission("view", profile) 执行：
    ├─ 调用 get_active_principals(user)
    │  → 返回 [Everyone, Authenticated, "user:123", "role:user"]
    │
    ├─ 调用 profile.__acl__()
    │  → 返回 [(Allow, "user:123", "view"), ...]
    │
    ├─ 匹配规则：
    │  "user:123" 在 principals 中？ ✅
    │  "view" 权限允许？ ✅
    │
    └─ 结果：允许访问
    ↓
4. 执行路由函数（返回档案详情）
```

---

## 关键改进点

### 改造前（无权限检查）
```python
@router.get("/{profile_id}")
def get_profile(profile_id: int, current_user=Depends(get_current_user)):
    profile = db.get(ProfileEntity, profile_id)
    # ❌ 任何用户都可以访问任意档案
    return profile
```

### 改造后（有权限检查）
```python
@router.get("/{profile_id}")
def get_profile(
    profile: ProfileEntity = Depends(get_profile_or_404),
    permission: str = Permission("view", profile)
):
    # ✅ 自动检查权限，无权限自动返回403
    return profile
```

---

## 下一步计划

### 推广到其他模块

- [ ] Trip模块（行程管理）
- [ ] Task模块（任务管理）
- [ ] SOS模块（紧急求助）
- [ ] Card模块（回忆卡片）
- [ ] Guide模块（景点讲解，可能不需要）

### 完善功能

- [ ] 添加管理员路由（`/api/admin/profiles`）
- [ ] 实现批量权限检查
- [ ] 添加权限审计日志
- [ ] 编写单元测试

---

## 常见问题

### Q1: 权限检查失败会返回什么？
A: 自动返回 `403 Forbidden`，无需手动处理。

### Q2: 如何创建管理员账户？
A: 执行SQL：
```sql
UPDATE users SET role='admin' WHERE id=1;
```

### Q3: 性能影响？
A: ACL在内存中检查，无数据库查询，性能优于传统RBAC。

### Q4: 如何调试权限问题？
A: 在 `get_active_principals()` 和 `__acl__()` 中添加日志：
```python
principals = get_active_principals(user)
logger.info(f"User principals: {principals}")

acl = profile.__acl__()
logger.info(f"Profile ACL: {acl}")
```

---

## 总结

Profile模块RBAC改造已完成，实现了：
- ✅ 资源级权限控制（只能访问自己的档案）
- ✅ 角色级权限控制（管理员可访问所有）
- ✅ 声明式权限定义（在Entity中定义ACL）
- ✅ 自动化权限检查（通过依赖注入）

**总代码变更**：
- 新增文件：2个（permissions.py, migration_add_role.sql）
- 修改Entity：3个（UserEntity, ElderEntity, ProfileEntity）
- 修改Controller：1个（ProfileController）
- 修改依赖：1个（requirements.txt）

**总工作量**：约1小时
