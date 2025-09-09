#!/bin/bash

# 太空探索0.1 - Git提交脚本
# 自动化提交和推送到GitHub

echo "🚀 太空探索0.1 - Git操作脚本"
echo "=================================="

# 检查git是否已初始化
if [ ! -d ".git" ]; then
    echo "❌ 错误: Git仓库未初始化"
    echo "请先运行: git init"
    exit 1
fi

# 检查是否有未提交的更改
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 没有未提交的更改"
    echo "是否要强制推送到GitHub? (y/n)"
    read -r force_push
    if [ "$force_push" != "y" ]; then
        echo "操作取消"
        exit 0
    fi
else
    echo "📋 发现未提交的更改:"
    git status --porcelain
    echo ""
    
    # 添加所有文件
    echo "📁 添加文件到Git..."
    git add .
    
    # 提交更改
    echo "💾 提交更改..."
    git commit -m "feat: 太空探索0.1初始版本

- 🌌 完整的3D星空场景，包含50,000个星点
- 🚀 6自由度飞船控制系统
- 🪐 动态行星系统，包含5个主要行星
- 🎮 多种控制方式（键盘+鼠标）
- 📊 实时UI显示系统
- 🔍 星系探索计数功能
- ⚡ 曲速引擎系统
- 🎯 自动导航功能
- 💊 燃料管理系统
- 🌟 物理引擎基础

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
    
    if [ $? -eq 0 ]; then
        echo "✅ 提交成功"
    else
        echo "❌ 提交失败"
        exit 1
    fi
fi

# 检查是否有远程仓库
if [ -z "$(git remote -v)" ]; then
    echo ""
    echo "🔗 未发现远程仓库"
    echo "请选择操作:"
    echo "1. 创建新的GitHub仓库"
    echo "2. 添加现有仓库URL"
    echo "3. 跳过远程推送"
    
    read -p "请选择 (1-3): " choice
    
    case $choice in
        1)
            echo "🌐 创建GitHub仓库..."
            
            # 检查是否有GitHub CLI
            if command -v gh &> /dev/null; then
                echo "检测到GitHub CLI，正在创建仓库..."
                
                # 获取当前目录名作为仓库名
                repo_name=$(basename "$(pwd)")
                
                # 创建仓库
                gh repo create "$repo_name" --public --description "太空探索0.1 - 3D星际探索游戏"
                
                if [ $? -eq 0 ]; then
                    echo "✅ 仓库创建成功"
                    
                    # 添加远程仓库
                    username=$(gh api user | jq -r '.login')
                    git remote add origin "https://github.com/$username/$repo_name.git"
                    
                    # 重命名分支为main
                    git branch -M main
                    
                    # 推送到GitHub
                    echo "📤 推送到GitHub..."
                    git push -u origin main
                    
                    if [ $? -eq 0 ]; then
                        echo "✅ 推送成功!"
                        echo ""
                        echo "🌉 项目URL: https://github.com/$username/$repo_name"
                        echo "🎮 游戏URL: https://$username.github.io/$repo_name/"
                    else
                        echo "❌ 推送失败"
                    fi
                else
                    echo "❌ 仓库创建失败"
                fi
            else
                echo "❌ 未检测到GitHub CLI"
                echo "请先安装GitHub CLI: https://cli.github.com/"
                echo "或者手动创建仓库后添加远程URL"
                
                # 手动添加远程仓库
                read -p "请输入仓库URL: " repo_url
                git remote add origin "$repo_url"
                git branch -M main
                git push -u origin main
            fi
            ;;
        2)
            echo "🔗 添加现有仓库..."
            read -p "请输入仓库URL: " repo_url
            git remote add origin "$repo_url"
            git branch -M main
            
            echo "📤 推送到GitHub..."
            git push -u origin main
            
            if [ $? -eq 0 ]; then
                echo "✅ 推送成功!"
            else
                echo "❌ 推送失败"
            fi
            ;;
        3)
            echo "⏭️  跳过远程推送"
            echo "✅ 本地提交完成"
            ;;
        *)
            echo "❌ 无效选择"
            exit 1
            ;;
    esac
else
    echo ""
    echo "📤 推送到远程仓库..."
    
    # 推送到GitHub
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo "✅ 推送成功!"
    else
        echo "❌ 推送失败"
        echo "可能需要先设置远程仓库"
        
        # 提供设置指导
        echo ""
        echo "🔧 设置指导:"
        echo "1. 在GitHub创建新仓库: https://github.com/new"
        echo "2. 复制仓库URL"
        echo "3. 运行: git remote add origin [你的仓库URL]"
        echo "4. 运行: git push -u origin main"
    fi
fi

echo ""
echo "🎉 操作完成!"
echo ""
echo "📋 项目信息:"
echo "   项目名称: 太空探索0.1"
echo "   版本: 0.1.0"
echo "   文件数量: $(find . -type f -not -path './.git/*' | wc -l)"
echo "   项目大小: $(du -sh . | cut -f1)"

# 显示下一步建议
echo ""
echo "💡 下一步建议:"
echo "1. 访问GitHub仓库设置GitHub Pages"
echo "2. 选择main分支作为源"
echo "3. 启用HTTPS"
echo "4. 分享游戏链接给朋友"

echo ""
echo "🚀 太空探索0.1 - 探索无限宇宙!"