#!/usr/bin/env bash
set -euo pipefail

# Render가 주입하는 동적 포트를 n8n이 사용하도록
export N8N_PORT="${PORT:-5678}"
echo "[boot] PORT=${PORT:-unset} -> N8N_PORT=${N8N_PORT}"

# 설정/데이터 디렉터리 권한 정리
umask 077
mkdir -p /home/node/.n8n
chown -R node:node /home/node/.n8n || true
chmod 700 /home/node/.n8n || true
touch /home/node/.n8n/config || true
chmod 600 /home/node/.n8n/config || true

# n8n 실행
exec n8n
