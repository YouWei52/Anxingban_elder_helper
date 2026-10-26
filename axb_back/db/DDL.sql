-- 安行伴数据库结构定义
-- MySQL 8.0+

use anxingban;
-- 子女用户表
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    nickname VARCHAR(50) NOT NULL COMMENT '昵称',
    phone VARCHAR(20) NOT NULL UNIQUE COMMENT '手机号',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    avatar_url TEXT COMMENT '头像URL',
    last_login_at DATETIME COMMENT '最后登录时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='子女用户表';

-- 老人用户表
CREATE TABLE IF NOT EXISTS elders (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    phone VARCHAR(20) NOT NULL UNIQUE COMMENT '手机号',
    password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
    health_info TEXT COMMENT '健康信息',
    interests TEXT COMMENT '兴趣爱好',
    wechat_webhook_url VARCHAR(500) COMMENT '企业微信Webhook URL',
    avatar_url TEXT COMMENT '头像URL',
    last_login_at DATETIME COMMENT '最后登录时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='老人用户表';

-- 家庭档案表
CREATE TABLE IF NOT EXISTS profiles (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    user_id INT NOT NULL COMMENT '关联的子女用户ID',
    elder_id INT NOT NULL COMMENT '关联的老人ID',
    relationship VARCHAR(50) DEFAULT '' COMMENT '关系（如：父亲、母亲）',
    emergency_contact VARCHAR(20) COMMENT '紧急联系人电话',
    notes TEXT COMMENT '备注信息',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_elder_id (elder_id),
    CONSTRAINT fk_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_profiles_elder FOREIGN KEY (elder_id) REFERENCES elders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='家庭档案表';

-- 行程表
CREATE TABLE IF NOT EXISTS trips (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    profile_id INT NOT NULL COMMENT '关联的档案ID',
    elder_id INT NOT NULL COMMENT '关联的老人ID',
    destination VARCHAR(200) NOT NULL COMMENT '目的地',
    travel_date DATE NOT NULL COMMENT '出行日期',
    notes TEXT COMMENT '备注',
    pass_token VARCHAR(255) COMMENT '动态通行码',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_profile_id (profile_id),
    INDEX idx_elder_id (elder_id),
    INDEX idx_travel_date (travel_date),
    CONSTRAINT fk_trips_profile FOREIGN KEY (profile_id) REFERENCES profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_trips_elder FOREIGN KEY (elder_id) REFERENCES elders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='行程表';

-- 代际任务表
CREATE TABLE IF NOT EXISTS tasks (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    trip_id INT NOT NULL COMMENT '关联的行程ID',
    user_id INT NOT NULL COMMENT '创建任务的子女用户ID',
    title VARCHAR(200) NOT NULL COMMENT '任务标题',
    description TEXT COMMENT '任务描述',
    user_completed BOOLEAN NOT NULL DEFAULT FALSE COMMENT '子女是否已完成',
    elder_completed BOOLEAN NOT NULL DEFAULT FALSE COMMENT '老人是否已完成',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_trip_id (trip_id),
    INDEX idx_user_id (user_id),
    CONSTRAINT fk_tasks_trip FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE,
    CONSTRAINT fk_tasks_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代际任务表';

-- 紧急求助表
CREATE TABLE IF NOT EXISTS sos_requests (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    elder_id INT NOT NULL COMMENT '发起求助的老人ID',
    trip_id INT COMMENT '关联的行程ID',
    location VARCHAR(500) COMMENT '位置信息',
    message TEXT COMMENT '求助信息',
    status VARCHAR(50) NOT NULL DEFAULT 'pending' COMMENT '状态：pending/handled/resolved',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    resolved_at DATETIME COMMENT '解决时间',
    INDEX idx_elder_id (elder_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    CONSTRAINT fk_sos_elder FOREIGN KEY (elder_id) REFERENCES elders(id) ON DELETE CASCADE,
    CONSTRAINT fk_sos_trip FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='紧急求助表';

-- 回忆卡片表
CREATE TABLE IF NOT EXISTS memory_cards (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    trip_id INT NOT NULL COMMENT '关联的行程ID',
    title VARCHAR(200) NOT NULL COMMENT '卡片标题',
    summary TEXT NOT NULL COMMENT '卡片摘要',
    image_url TEXT COMMENT '卡片图片URL',
    card_json TEXT NOT NULL COMMENT '卡片数据JSON',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_trip_id (trip_id),
    INDEX idx_created_at (created_at),
    CONSTRAINT fk_cards_trip FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='回忆卡片表';
