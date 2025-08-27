@echo off
chcp 65001 >nul
title V免签 Windows Docker 一键部署

echo.
echo 🐳 V免签 Windows Docker 一键部署
echo =====================================
echo.

:: 检查Docker是否安装
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker 未安装，请先安装 Docker Desktop for Windows
    echo 下载地址: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

echo ✅ Docker 环境检查通过
echo.

:: 停止现有容器
echo 🛑 停止现有容器...
docker-compose down >nul 2>&1

:: 启动服务
echo 🚀 启动V免签服务...
docker-compose up -d --build

if errorlevel 1 (
    echo ❌ 服务启动失败，请检查错误信息
    pause
    exit /b 1
)

echo ✅ 服务启动成功！
echo.
echo ⏳ 等待服务完全启动...
timeout /t 30 /nobreak >nul

echo.
echo 🎉 部署完成！
echo =====================================
echo 📱 V免签主应用: http://localhost:5001
echo 🗄️  数据库管理: http://localhost:8080
echo 📋 默认账号: admin
echo 🔑 默认密码: admin
echo.

:: 打开浏览器
start http://localhost:5001

echo 按任意键退出...
pause >nul
