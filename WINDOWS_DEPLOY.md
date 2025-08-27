# 🖥️ V免签 Windows Docker 部署指南

## ⚡ 超简单 - Windows一键部署

### 🎯 三种部署方式

#### 方式一：双击运行（最简单）
1. 下载项目到本地
2. 双击运行 `deploy-windows.bat`
3. 等待自动完成部署

#### 方式二：PowerShell脚本
```powershell
# 右键以管理员身份运行PowerShell
.\deploy-windows.ps1
```

#### 方式三：手动命令
```powershell
# 1. 克隆项目
git clone https://github.com/ssfxx0923/vca.git
cd vca

# 2. 启动服务
docker-compose up -d
```

## 📋 环境要求

### 必需软件
- **Windows 10/11** (64位)
- **Docker Desktop for Windows** 
  - 下载：https://www.docker.com/products/docker-desktop/
  - 建议启用WSL 2后端

### 系统配置
- 内存：至少4GB (推荐8GB)
- 磁盘：至少2GB可用空间
- 处理器：支持虚拟化

## 🚀 快速开始

### 1. 安装Docker Desktop
1. 下载并安装 Docker Desktop for Windows
2. 启动Docker Desktop
3. 等待Docker服务启动完成

### 2. 下载V免签项目
```powershell
# 方式A：使用Git
git clone https://github.com/ssfxx0923/vca.git

# 方式B：直接下载
# 访问 https://github.com/ssfxx0923/vca/archive/main.zip
# 下载并解压到本地文件夹
```

### 3. 一键部署
在项目根目录下：
```batch
# 双击运行
deploy-windows.bat

# 或者在PowerShell中执行
.\deploy-windows.ps1
```

## 📱 访问地址

部署成功后：
- **V免签主应用**: http://localhost:5001
- **数据库管理**: http://localhost:8080
- **默认账号**: admin
- **默认密码**: admin

## 🔧 端口冲突解决

如果5001端口被占用，脚本会自动使用备用端口：
- **V免签主应用**: http://localhost:8001
- **数据库管理**: http://localhost:8002

或者手动修改 `docker-compose.yml` 中的端口：
```yaml
services:
  app:
    ports:
      - "8001:80"  # 改为你想要的端口
```

## 🛠️ 常用操作

### 查看服务状态
```powershell
docker-compose ps
```

### 查看日志
```powershell
# 查看所有日志
docker-compose logs

# 实时查看日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs app
```

### 重启服务
```powershell
docker-compose restart
```

### 停止服务
```powershell
docker-compose down
```

### 完全重置
```powershell
# 停止并删除所有容器、网络、数据卷
docker-compose down -v

# 重新启动
docker-compose up -d --build
```

## 🔍 故障排除

### Docker Desktop未启动
**错误**: `docker: command not found` 或连接错误
**解决**: 启动Docker Desktop，等待状态变为"Running"

### 端口被占用
**错误**: `bind: address already in use`
**解决**: 
1. 使用脚本自动检测端口
2. 或手动修改docker-compose.yml中的端口

### 内存不足
**错误**: MySQL启动失败或容器重启
**解决**: 
1. 关闭其他占用内存的程序
2. 在Docker Desktop设置中增加内存分配

### 权限问题
**错误**: 文件访问被拒绝
**解决**: 右键以管理员身份运行PowerShell

## 💡 优化建议

### 性能优化
1. **Docker Desktop设置**
   - 内存：4-8GB
   - CPU：2-4核心
   - 磁盘镜像大小：至少60GB

2. **WSL 2后端**（推荐）
   - 性能更好
   - 资源占用更低

### 安全设置
1. **修改默认密码**
   - 登录后立即修改admin密码

2. **防火墙设置**
   - 只允许本地访问：127.0.0.1:5001
   - 或配置安全的内网访问

## 📞 获取帮助

- **项目地址**: https://github.com/ssfxx0923/vca
- **Docker官方文档**: https://docs.docker.com/desktop/windows/
- **问题反馈**: 在GitHub创建Issue

## ⚠️ 注意事项

1. **仅供学习使用** - 请勿用于商业用途
2. **数据备份** - 定期备份重要数据
3. **安全防护** - 不要暴露到公网
4. **资源监控** - 定期检查系统资源使用情况

## 🎉 完成！

现在您已经在Windows上成功部署了V免签系统！享受便捷的Docker容器化部署体验。
