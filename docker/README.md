# V免签 Docker 部署指南

## 🚀 快速开始

### 一键部署（推荐）

```bash
# 克隆项目
git clone https://github.com/szvone/vmqphp.git
cd vmqphp

# 添加执行权限
chmod +x deploy.sh

# 运行一键部署脚本
./deploy.sh
```

### 手动部署

```bash
# 1. 启动服务
docker-compose up -d

# 2. 查看状态
docker-compose ps

# 3. 查看日志
docker-compose logs -f
```

## 📋 服务说明

| 服务 | 端口 | 说明 |
|------|------|------|
| app | 80 | V免签主应用 |
| mysql | 3306 | MySQL数据库 |
| redis | 6379 | Redis缓存 |
| phpmyadmin | 8080 | 数据库管理界面 |

## 🔧 配置说明

### 环境变量配置

复制 `docker/env.example` 为 `.env` 并修改配置：

```bash
cp docker/env.example .env
```

### 主要配置项

- `DB_PASSWORD`: 数据库密码
- `MYSQL_ROOT_PASSWORD`: MySQL root密码
- `APP_PORT`: 应用端口（默认80）
- `DOMAIN`: 域名配置

## 📱 访问地址

- **主应用**: http://localhost
- **数据库管理**: http://localhost:8080
- **默认账号**: admin / admin

## 🛠️ 常用命令

```bash
# 查看服务状态
docker-compose ps

# 查看实时日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 完全重建
docker-compose down
docker-compose up -d --build

# 进入应用容器
docker-compose exec app sh

# 进入数据库容器
docker-compose exec mysql mysql -u root -p

# 备份数据库
docker-compose exec mysql mysqldump -u root -p vmq > backup.sql

# 恢复数据库
docker-compose exec -T mysql mysql -u root -p vmq < backup.sql
```

## 🔐 安全配置

### 生产环境建议

1. **修改默认密码**
   ```bash
   # 修改 .env 文件中的密码
   DB_PASSWORD=your_secure_password
   MYSQL_ROOT_PASSWORD=your_root_password
   ```

2. **使用HTTPS**
   ```yaml
   # 在 docker-compose.yml 中添加SSL配置
   volumes:
     - ./ssl:/etc/nginx/ssl
   ```

3. **限制端口访问**
   ```yaml
   # 只暴露必要端口
   ports:
     - "127.0.0.1:80:80"  # 只允许本地访问
   ```

## 📊 监控和日志

### 查看各服务日志

```bash
# 应用日志
docker-compose logs app

# 数据库日志
docker-compose logs mysql

# Nginx日志
docker-compose exec app tail -f /var/log/nginx/access.log
```

### 性能监控

```bash
# 查看容器资源使用
docker stats

# 查看容器详情
docker-compose exec app top
```

## 🐛 故障排除

### 常见问题

1. **端口冲突**
   ```bash
   # 修改 docker-compose.yml 中的端口映射
   ports:
     - "8080:80"  # 改为其他端口
   ```

2. **权限问题**
   ```bash
   # 重新设置权限
   docker-compose exec app chown -R www-data:www-data /var/www/html
   ```

3. **数据库连接失败**
   ```bash
   # 检查数据库状态
   docker-compose exec mysql mysql -u root -p -e "SHOW DATABASES;"
   ```

4. **清理重建**
   ```bash
   # 完全清理并重建
   docker-compose down -v
   docker system prune -f
   docker-compose up -d --build
   ```

## 📋 维护任务

### 备份策略

```bash
# 创建备份脚本
cat > backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec -T mysql mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" vmq > "backup_${DATE}.sql"
tar czf "vmq_backup_${DATE}.tar.gz" backup_${DATE}.sql public/
echo "备份完成: vmq_backup_${DATE}.tar.gz"
EOF

chmod +x backup.sh
```

### 更新应用

```bash
# 拉取最新代码
git pull

# 重新构建
docker-compose down
docker-compose up -d --build
```

## 🔧 自定义配置

### 修改PHP配置

编辑 `docker/php.ini` 文件，然后重建容器：

```bash
docker-compose down
docker-compose up -d --build
```

### 修改Nginx配置

编辑 `docker/nginx.conf` 文件，然后重启：

```bash
docker-compose restart app
```

## 📞 技术支持

- GitHub Issues: https://github.com/szvone/vmqphp/issues
- 原项目文档: https://github.com/szvone/vmqphp/blob/master/README.md

## 📄 许可证

本项目遵循原项目的开源协议。仅供学习交流使用，请勿用于商业用途。
