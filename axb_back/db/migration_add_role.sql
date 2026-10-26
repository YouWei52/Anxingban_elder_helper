-- 添加role字段到users和elders表
-- 执行命令: mysql -u ivan -p123456 anxingban < db/migration_add_role.sql

-- 为users表添加role字段
ALTER TABLE users ADD COLUMN role VARCHAR(20) DEFAULT 'user' COMMENT '角色：user/admin';

-- 为elders表添加role字段  
ALTER TABLE elders ADD COLUMN role VARCHAR(20) DEFAULT 'elder' COMMENT '角色：elder/admin';

-- 创建索引以提高查询性能
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_elders_role ON elders(role);

-- 可选：创建第一个管理员用户（取消注释以使用）
-- UPDATE users SET role='admin' WHERE id=1;
