#!/bin/sh
set -eu

echo "[boot] PORT=${PORT:-unset}"

# 0) (중요) config가 0바이트거나 깨져 있으면 삭제
#    - n8n은 이 파일이 없으면 환경변수로 설정을 읽습니다.
if [ -f /home/node/.n8n/config ]; then
  if [ ! -s /home/node/.n8n/config ]; then
    echo "[boot] /home/node/.n8n/config is empty. Removing."
    rm -f /home/node/.n8n/config || true
  fi
fi

# 1) 디렉터리 준비 (root로 실행 중)
umask 077
mkdir -p /home/node/.n8n || true

# 2) 가능하면 소유/권한 정리 (마운트 정책상 실패해도 계속 진행)
chown -R node:node /home/node/.n8n 2>/dev/null || true
chmod 700 /home/node/.n8n 2>/dev/null || true
# config 파일은 "존재할 때만" 권한만 조정 (생성/덮어쓰기 하지 않음)
[ -f /home/node/.n8n/config ] && chmod 600 /home/node/.n8n/config 2>/dev/null || true

# 3) Render 동적 포트를 n8n에 주입
export N8N_PORT="${PORT:-5678}"
echo "[boot] N8N_PORT=${N8N_PORT}"

# 4) node 유저로 n8n 실행 (su-exec는 Alpine의 lightweight sudo)
exec su-exec node n8n
