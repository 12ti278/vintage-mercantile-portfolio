@echo off
chcp 65001 >nul
setlocal

cd /d "%~dp0"

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║     🏺  时光商社 · 项目文档 - 部署到 GitHub Pages           ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM ==========================================
REM 第 1 步：检查 git
REM ==========================================
echo [1/4] 检查 Git 环境...
where git >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到 Git，请先安装 Git
    echo    下载地址: https://git-scm.com/download/win
    pause
    exit /b 1
)
echo    ✅ Git 已就绪
echo.

REM ==========================================
REM 第 2 步：检查 GitHub 认证
REM ==========================================
echo [2/4] 检查 GitHub 认证...
git remote get-url origin >nul 2>&1
if not errorlevel 1 (
    echo    检测到已有远程仓库，直接推送...
    goto :push
)

echo.
echo    ┌─────────────────────────────────────────────┐
echo    │  请选择部署方式:                            │
echo    │                                             │
echo    │  1. 推送到已有仓库（推荐）                   │
echo    │  2. 创建新仓库并推送                         │
echo    └─────────────────────────────────────────────┘
echo.
set /p choice=请输入选项 (1/2): 

if "!choice!"=="2" (
    echo.
    echo    正在创建新仓库...
    echo.
    set /p reponame=请输入仓库名 (如 vintage-mercantile-portfolio): 
    gh repo create !reponame! --public --description "时光商社 · 复古商城项目文档" --source=. --push
    if errorlevel 1 (
        echo ❌ 创建失败，请检查 gh CLI 是否已安装并登录
        echo    安装: winget install --id GitHub.cli
        echo    登录: gh auth login
        pause
        exit /b 1
    )
    goto :done
)

REM 方式 1: 已有仓库
echo.
set /p repourl=请输入 GitHub 仓库地址 (如 https://github.com/12ti278/vintage-mercantile-portfolio.git): 
if "!repourl!"=="" (
    echo ❌ 仓库地址不能为空
    pause
    exit /b 1
)

git remote add origin !repourl!
if errorlevel 1 (
    echo    远程仓库已存在，更新地址...
    git remote set-url origin !repourl!
)

:push
REM ==========================================
REM 第 3 步：推送到 GitHub
REM ==========================================
echo.
echo [3/4] 推送到 GitHub...
git branch -M main
git push -u origin main
if errorlevel 1 (
    echo ❌ 推送失败，请检查仓库地址和权限
    pause
    exit /b 1
)
echo    ✅ 推送成功
echo.

REM ==========================================
REM 第 4 步：启用 GitHub Pages
REM ==========================================
echo [4/4] 启用 GitHub Pages...
where gh >nul 2>&1
if not errorlevel 1 (
    gh api repos/{owner}/{repo}/pages -X PUT -f source[branch]=main -f source[path]=/ >nul 2>&1
    if errorlevel 1 (
        echo    ⚠️  自动启用 Pages 失败，请手动在 GitHub 仓库设置中开启
    ) else (
        echo    ✅ GitHub Pages 已启用
    )
) else (
    echo    ⚠️  未安装 gh CLI，请手动在 GitHub 仓库设置中开启 Pages
)

:done
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                      🎉 部署完成！                           ║
echo ╠══════════════════════════════════════════════════════════════╣
echo ║                                                              ║
echo ║  项目文档已上传到 GitHub！                                   ║
echo ║                                                              ║
echo ║  📂 文件清单:                                                ║
echo ║     • index.html          - 导航首页                        ║
echo ║     • mall-project.html   - 项目成果                        ║
echo ║     • mall-evidence.html  - 过程证据                        ║
echo ║     • mall-homework.html  - 阶段作业                        ║
echo ║     • assets/             - 图片资源                        ║
echo ║                                                              ║
echo ║  🌐 访问方式:                                               ║
echo ║     1. 在 GitHub 仓库 Settings → Pages 中启用                ║
echo ║     2. 选择 main 分支，根目录                                ║
echo ║     3. 等待几分钟后访问:                                     ║
echo ║        https://你的用户名.github.io/仓库名/                  ║
echo ║                                                              ║
echo ║  🔗 项目入口:                                               ║
echo ║     • 项目成果 → mall-project.html                          ║
echo ║     • 过程证据 → mall-evidence.html                         ║
echo ║     • 阶段作业 → mall-homework.html                         ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
endlocal
