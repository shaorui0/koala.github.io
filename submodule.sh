#!/bin/bash

# ================================
# 配置部分：请根据实际情况修改
# ================================

# Hexo 项目的根目录路径
HEXO_ROOT="/blog-original"

# 新的 _posts 仓库的远程地址（HTTPS 或 SSH）
# POSTS_REPO_URL="https://github.com/shaorui0/blog-md-source.git"
# 如果使用 SSH，请使用如下格式：
POSTS_REPO_URL="git@github.com:shaorui0/blog-md-source.git"

# _posts 目录相对于 Hexo 根目录的路径
POSTS_DIR="source/_posts"

# 要使用的分支（通常为 main 或 master）
POSTS_BRANCH="hexo"

# ================================
# 脚本执行部分
# ================================

echo "==============================="
echo "将 Hexo 的 _posts 目录迁移到独立仓库并添加为子模块"
echo "==============================="

# 1. 进入 Hexo 项目根目录
cd "$HEXO_ROOT" || { echo "Hexo 根目录不存在！请检查路径：$HEXO_ROOT"; exit 1; }

# 2. 检查 _posts 目录是否存在
if [ ! -d "$POSTS_DIR" ]; then
    echo "目录 $POSTS_DIR 不存在，请检查 Hexo 项目。"
    exit 1
fi

# 3. 复制 _posts 目录到临时位置以备份
echo "备份当前的 $POSTS_DIR 目录到临时位置..."
cp -r "$POSTS_DIR" "${POSTS_DIR}_backup"

# 4. 初始化新的 _posts 仓库
echo "初始化新的 $POSTS_DIR 仓库..."
cd "$POSTS_DIR" || { echo "无法进入目录 $POSTS_DIR"; exit 1; }

# 检查是否已经是一个 Git 仓库
if [ -d ".git" ]; then
    echo "$POSTS_DIR 已经是一个 Git 仓库，跳过初始化。"
else
    git init
    git add .
    git commit -m "Initial commit of _posts"
fi

# 5. 添加远程仓库并推送
echo "添加远程仓库并推送..."
git remote remove origin 2>/dev/null
git remote add origin "$POSTS_REPO_URL"

# 检查当前分支是否为指定的分支
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "$POSTS_BRANCH" ]; then
    git checkout -b "$POSTS_BRANCH"
fi

# 推送到远程仓库
git push -u origin "$POSTS_BRANCH"

# 6. 返回 Hexo 根目录
cd "$HEXO_ROOT" || { echo "无法返回 Hexo 根目录。"; exit 1; }

# 7. 移除当前的 _posts 目录并提交更改
echo "从主仓库中移除 $POSTS_DIR 目录..."
git rm -r "$POSTS_DIR"
git commit -m "Remove _posts directory to add as submodule"

# 8. 添加 _posts 作为子模块
echo "添加 $POSTS_DIR 作为子模块..."
git submodule add "$POSTS_REPO_URL" "$POSTS_DIR"

# 9. 提交子模块的添加
echo "提交子模块的更改..."
git commit -m "Add _posts as a submodule"

# 10. 推送主仓库的更改
echo "推送主仓库的更改到远程..."
git push origin "$POSTS_BRANCH"

# 11. 清理临时备份
echo "清理临时备份目录..."
rm -rf "${POSTS_DIR}_backup"

echo "==============================="
echo "成功将 $POSTS_DIR 迁移到独立仓库并添加为子模块！"
echo "==============================="
