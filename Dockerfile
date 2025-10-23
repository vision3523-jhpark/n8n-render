FROM n8nio/n8n:latest

# Alpine이면 apk 사용
USER root
RUN apk add --no-cache tzdata

# 엔트리 스크립트 복사 + 권한
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh && chown node:node /usr/local/bin/entry.sh

# 기본 유저 복귀
USER node

# entry.sh를 통해 n8n 실행 (동적 PORT 주입/권한 정리)
ENTRYPOINT ["/usr/local/bin/entry.sh"]
