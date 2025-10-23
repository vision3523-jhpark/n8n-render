FROM n8nio/n8n:latest

# root로 필요한 패키지 설치
USER root
RUN apk add --no-cache tzdata su-exec \
 && ln -sf /sbin/su-exec /usr/local/bin/su-exec

# 엔트리 스크립트 복사 + 권한
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh

# ENTRYPOINT는 root로 실행 (스크립트 안에서 node 전환)
ENTRYPOINT ["/usr/local/bin/entry.sh"]
