# 🐳 V免签 Docker 一键部署指南

## ⚡ 超级简单 - 三步部署

### 第一步：环境准备

**安装 Docker 和 Docker Compose：**

```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com | bash
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# CentOS/RHEL
sudo yum install -y docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

**Windows 用户：**
直接安装 [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 第二步：下载项目

```bash
# 方式一：使用 git（推荐）
git clone https://github.com/szvone/vmqphp.git
cd vmqphp

# 方式二：直接下载
wget https://github.com/szvone/vmqphp/archive/master.zip
unzip master.zip
cd vmqphp-master
```

### 第三步：一键部署

```bash
# 给脚本执行权限
chmod +x deploy.sh

# 运行一键部署
./deploy.sh
```

## 🎉 完成！

访问地址：
- **主应用**: http://localhost
- **数据库管理**: http://localhost:8080
- **默认账号**: admin
- **默认密码**: admin

## 🔧 手动部署（高级用户）

如果您想自定义配置，可以手动执行：

```bash
# 1. 配置环境（可选）
cp docker/env.example .env
# 编辑 .env 文件修改配置

# 2. 启动服务
docker-compose up -d

# 3. 查看状态
docker-compose ps
```

## 📱 项目结构

```
vmqphp/
├── docker-compose.yml    # Docker编排文件
├── Dockerfile           # 应用镜像构建文件
├── deploy.sh           # 一键部署脚本
├── docker/             # Docker配置目录
│   ├── nginx.conf      # Nginx配置
│   ├── php.ini         # PHP配置
│   ├── supervisord.conf # 进程管理配置
│   └── README.md       # 详细文档
└── ...                 # 其他项目文件
```

## 🛟 遇到问题？

### 常见问题快速解决

**1. 端口被占用**
```bash
# 修改 docker-compose.yml 中的端口
ports:
  - "8080:80"  # 将80改为8080
```

**2. 权限问题**
```bash
sudo chown -R $USER:$USER .
```

**3. 完全重置**
```bash
docker-compose down -v
docker system prune -f
./deploy.sh
```

**4. 查看日志**
```bash
docker-compose logs -f
```

## 📞 需要帮助？

1. 查看详细文档：`docker/README.md`
2. 查看项目原始文档：`README.md`
3. 提交 Issue：https://github.com/szvone/vmqphp/issues

---

**🎯 提示**：整个部署过程不超过5分钟！如果遇到问题，95%的情况都可以通过重新运行 `./deploy.sh` 解决。
