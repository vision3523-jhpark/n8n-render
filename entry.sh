#!/usr/bin/env bash
set -euo pipefail

# Render의 동적 포트를 n8n에 주입
export N8N_PORT="${PORT:-5678}"
echo "[boot] PORT=${PORT:-unset} -> N8N_PORT=${N8N_PORT}"

# 설정 디렉터리/파일 권한 정리
umask 077
mkdir -p /home/node/.n8n
chown -R node:node /home/node/.n8n || true
chmod 700 /home/node/.n8n || true
touch /home/node/.n8n/config || true
chmod 600 /home/node/.n8n/config || true

exec n8n
