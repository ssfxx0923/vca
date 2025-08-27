# V免签 Windows Docker 一键部署脚本
# 使用方法: 右键以管理员身份运行 PowerShell，然后执行此脚本

Write-Host "🐳 V免签 Windows Docker 一键部署脚本" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# 检查Docker是否安装
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker 未安装，请先安装 Docker Desktop for Windows" -ForegroundColor Red
    Write-Host "下载地址: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    exit 1
}

# 检查Docker是否运行
try {
    docker version | Out-Null
} catch {
    Write-Host "❌ Docker 未运行，请启动 Docker Desktop" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Docker 环境检查通过" -ForegroundColor Green

# 检查项目文件
if (!(Test-Path "docker-compose.yml")) {
    Write-Host "❌ 当前目录下没有找到 docker-compose.yml 文件" -ForegroundColor Red
    Write-Host "请确保在项目根目录下运行此脚本" -ForegroundColor Yellow
    exit 1
}

# 停止现有容器
Write-Host "🛑 停止现有容器..." -ForegroundColor Yellow
docker-compose down 2>$null

# 检查端口占用
$port5001 = Get-NetTCPConnection -LocalPort 5001 -ErrorAction SilentlyContinue
$port8080 = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue

if ($port5001) {
    Write-Host "⚠️  端口5001被占用，将使用端口8001" -ForegroundColor Yellow
    $useAltPorts = $true
} else {
    $useAltPorts = $false
}

# 如果端口被占用，创建覆盖配置
if ($useAltPorts) {
    @"
version: '3.8'
services:
  app:
    ports:
      - "8001:80"
  
  phpmyadmin:
    ports:
      - "8002:80"
"@ | Out-File -FilePath "docker-compose.override.yml" -Encoding UTF8
    Write-Host "📝 已创建端口覆盖配置文件" -ForegroundColor Blue
}

# 启动服务
Write-Host "🚀 启动V免签服务..." -ForegroundColor Green
docker-compose up -d --build

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 服务启动成功！" -ForegroundColor Green
    
    # 等待服务启动
    Write-Host "⏳ 等待服务完全启动..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    
    # 显示访问信息
    Write-Host ""
    Write-Host "🎉 部署完成！" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Green
    
    if ($useAltPorts) {
        Write-Host "📱 V免签主应用: http://localhost:8001" -ForegroundColor Cyan
        Write-Host "🗄️  数据库管理: http://localhost:8002" -ForegroundColor Cyan
    } else {
        Write-Host "📱 V免签主应用: http://localhost:5001" -ForegroundColor Cyan
        Write-Host "🗄️  数据库管理: http://localhost:8080" -ForegroundColor Cyan
    }
    
    Write-Host "📋 默认账号: admin" -ForegroundColor Yellow
    Write-Host "🔑 默认密码: admin" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔧 常用命令:" -ForegroundColor Blue
    Write-Host "查看状态: docker-compose ps" -ForegroundColor Gray
    Write-Host "查看日志: docker-compose logs -f" -ForegroundColor Gray
    Write-Host "重启服务: docker-compose restart" -ForegroundColor Gray
    Write-Host "停止服务: docker-compose down" -ForegroundColor Gray
    
    # 尝试打开浏览器
    if ($useAltPorts) {
        Start-Process "http://localhost:8001"
    } else {
        Start-Process "http://localhost:5001"
    }
    
} else {
    Write-Host "❌ 服务启动失败，请检查错误信息" -ForegroundColor Red
    Write-Host "建议执行: docker-compose logs" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📚 更多信息请查看: https://github.com/ssfxx0923/vca" -ForegroundColor Blue
