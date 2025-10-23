#!/bin/sh
set -eu

echo "[boot] PORT=${PORT:-unset}"

# config가 0바이트(깨짐)면 삭제 → 환경변수 기반으로 부팅
if [ -f /home/node/.n8n/config ] && [ ! -s /home/node/.n8n/config ]; then
  echo "[boot] /home/node/.n8n/config is empty. Removing."
  rm -f /home/node/.n8n/config || true
fi

# 디렉터리 준비 (root로 실행됨)
umask 077
mkdir -p /home/node/.n8n || true
# 권한 정리는 실패해도 계속 진행
chown -R node:node /home/node/.n8n 2>/dev/null || true
chmod 700 /home/node/.n8n 2>/dev/null || true
[ -f /home/node/.n8n/config ] && chmod 600 /home/node/.n8n/config 2>/dev/null || true

# Render 동적 포트를 n8n에 주입
N8N_PORT="${PORT:-5678}"
export N8N_PORT
echo "[boot] N8N_PORT=${N8N_PORT}"

# su-exec/gosu가 있으면 node로 전환, 없으면 root로라도 기동
if [ -x /sbin/su-exec ]; then
  exec /sbin/su-exec node n8n
elif command -v su-exec >/dev/null 2>&1; then
  exec su-exec node n8n
elif command -v gosu >/dev/null 2>&1; then
  exec gosu node n8n
else
  echo "[boot] su-exec/gosu not found. Running as root (temporary)."
  exec n8n
fi
