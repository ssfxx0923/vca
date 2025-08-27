#!/bin/bash

# V免签 Docker 一键部署脚本
# 作者: AI Assistant
# 使用方法: chmod +x deploy.sh && ./deploy.sh

set -e

echo "🐳 V免签 Docker 一键部署脚本"
echo "================================"

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    echo "Ubuntu/Debian: sudo apt update && sudo apt install docker.io docker-compose"
    echo "CentOS/RHEL: sudo yum install docker docker-compose"
    exit 1
fi

# 检查Docker Compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 创建必要的目录
echo "📁 创建必要的目录..."
mkdir -p docker/logs
mkdir -p data/mysql
mkdir -p data/redis

# 检查配置文件
if [ ! -f "config/database.php" ]; then
    echo "❌ 配置文件不存在，请确保在项目根目录下运行此脚本"
    exit 1
fi

# 更新数据库配置文件
echo "⚙️  更新数据库配置文件..."
cat > config/database.php << 'EOF'
<?php
return [
    // 数据库类型
    'type'            => 'mysql',
    // 服务器地址
    'hostname'        => getenv('DB_HOST') ?: 'mysql',
    // 数据库名
    'database'        => getenv('DB_DATABASE') ?: 'vmq',
    // 用户名
    'username'        => getenv('DB_USERNAME') ?: 'vmq_user',
    // 密码
    'password'        => getenv('DB_PASSWORD') ?: 'vmq_password123',
    // 端口
    'hostport'        => getenv('DB_PORT') ?: '3306',
    // 连接dsn
    'dsn'             => '',
    // 数据库连接参数
    'params'          => [],
    // 数据库编码默认采用utf8
    'charset'         => 'utf8mb4',
    // 数据库表前缀
    'prefix'          => '',
    // 数据库调试模式
    'debug'           => false,
    // 数据库部署方式:0 集中式(单一服务器),1 分布式(主从服务器)
    'deploy'          => 0,
    // 数据库读写是否分离 主从式有效
    'rw_separate'     => false,
    // 读写分离后 主服务器数量
    'master_num'      => 1,
    // 指定从服务器序号
    'slave_no'        => '',
    // 自动读取主库数据
    'read_master'     => false,
    // 是否严格检查字段是否存在
    'fields_strict'   => true,
    // 数据集返回类型
    'resultset_type'  => 'array',
    // 自动写入时间戳字段
    'auto_timestamp'  => false,
    // 时间字段取出后的默认时间格式
    'datetime_format' => 'Y-m-d H:i:s',
    // 是否需要进行SQL性能分析
    'sql_explain'     => false,
    // 是否需要断线重连
    'break_reconnect' => false,
];
EOF

# 停止现有容器
echo "🛑 停止现有容器..."
docker-compose down 2>/dev/null || true

# 清理旧的镜像（可选）
read -p "是否清理旧的Docker镜像？(y/N): " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🧹 清理旧的Docker镜像..."
    docker system prune -f
fi

# 构建并启动容器
echo "🚀 构建并启动容器..."
docker-compose up -d --build

# 等待MySQL启动
echo "⏳ 等待MySQL启动..."
sleep 30

# 检查服务状态
echo "📊 检查服务状态..."
docker-compose ps

# 等待应用启动
echo "⏳ 等待应用启动..."
sleep 10

# 健康检查
echo "🏥 进行健康检查..."
if curl -f http://localhost:8080/health > /dev/null 2>&1; then
    echo "✅ 应用启动成功！"
else
    echo "⚠️  应用可能还在启动中，请稍后检查"
fi

echo ""
echo "🎉 部署完成！"
echo "================================"
echo "📱 应用访问地址: http://localhost:8080"
echo "🗄️  数据库管理: http://localhost:8081"
echo "📋 默认账号: admin"
echo "🔑 默认密码: admin"
echo ""
echo "🔧 常用命令:"
echo "查看日志: docker-compose logs -f"
echo "重启服务: docker-compose restart"
echo "停止服务: docker-compose down"
echo "进入容器: docker-compose exec app sh"
echo ""
echo "📚 更多信息请查看 README.md"
