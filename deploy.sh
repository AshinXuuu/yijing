#!/usr/bin/env bash
# 周易研习 · 一键发布脚本
#
# 用法：
#   ./deploy.sh                      # 自动用时间戳作为 commit 信息
#   ./deploy.sh "lesson 2 坤"         # 自定义 commit 信息
#
# 做的事：
#   1. git add -A
#   2. git commit
#   3. git push 到 GitHub
#   4. SSH 到腾讯云服务器执行 git pull
#
# ===== 服务器信息 =====
SSH_USER="ubuntu"                        # 服务器用户名
SSH_HOST="124.222.164.101"               # 服务器公网 IP
SSH_PORT="22"                            # SSH 端口
REMOTE_PATH="/var/www/yijing"            # 服务器上 yijing 仓库的路径
SITE_URL="https://yijing.xxcode.work"    # 部署后的访问地址
# ====================

set -e
cd "$(dirname "$0")"

# 1. commit 信息
if [ -n "$1" ]; then
  MSG="$1"
else
  MSG="update: $(date '+%Y-%m-%d %H:%M')"
fi

# 2. add + commit（如无改动则跳过）
git add -A
if git diff --cached --quiet; then
  echo "ℹ️  本地无新改动，跳过 commit"
else
  git commit -m "$MSG"
  echo "✅ 已 commit：$MSG"
fi

# 3. push 到 GitHub
echo "🚀 推送到 GitHub..."
git push

# 4. SSH 到服务器拉取最新代码
echo "🔄 通知服务器更新..."
ssh -p "$SSH_PORT" "${SSH_USER}@${SSH_HOST}" "cd ${REMOTE_PATH} && git pull"

echo ""
echo "✅ 全部完成。${SITE_URL} 已更新。"
