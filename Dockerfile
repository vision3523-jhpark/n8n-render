FROM n8nio/n8n:latest

# 타임존 패키지 설치(로그/cron 정합성)
USER root
RUN apk add --no-cache tzdata

# 엔트리 스크립트 복사
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh && chown node:node /entry.sh

# 기본 실행자 복귀
USER node

# n8n을 바로 실행하지 말고 엔트리 스크립트를 통해 실행
CMD ["/entry.sh"]
