FROM n8nio/n8n:latest

# tzdata 설치 (베이스 이미지가 Debian/Ubuntu 계열임. apk(X) 아닌 apt(Y))
USER root
RUN apt-get update \
 && apt-get install -y --no-install-recommends tzdata \
 && rm -rf /var/lib/apt/lists/*

# 엔트리 스크립트 복사 + 실행권한
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh \
 && chown node:node /usr/local/bin/entry.sh

# n8n 기본 유저로 실행
USER node

# entry.sh 통해 n8n 실행 (Start Command 필요 없음)
ENTRYPOINT ["/usr/local/bin/entry.sh"]
