#!/bin/sh
# 独立安装：仓库目录 → ~/.config/nvim
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

if ! command -v nvim >/dev/null 2>&1; then
    echo "警告: 未检测到 nvim，仍链接配置目录"
fi

mkdir -p "$(dirname "$DEST")"
if [ -L "$DEST" ]; then
    cur="$(readlink "$DEST")"
    if [ "$cur" = "$ROOT" ]; then
        echo "nvim 已链接到 $ROOT"
        exit 0
    fi
    echo "更新符号链接 $DEST → $ROOT"
    ln -sfn "$ROOT" "$DEST"
elif [ -e "$DEST" ]; then
    backup="${DEST}.backup.$(date +%Y%m%d%H%M%S)"
    echo "$DEST 已存在，备份到 $backup"
    mv "$DEST" "$backup"
    ln -s "$ROOT" "$DEST"
    echo "已创建 $DEST → $ROOT"
else
    ln -s "$ROOT" "$DEST"
    echo "已创建 $DEST → $ROOT"
fi

echo "nvim 配置完成（首次可在 nvim 内 :Lazy sync）"
