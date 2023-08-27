# ./srcs/requirements/nginx/Dockerfile
FROM debian:bullseye

# 환경변수 설정 (환경 변수는 .env 파일에서 오게 됩니다)
ENV DOMAIN_NAME=hyeondle.42.fr

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    nginx \
    openssl

# SSL 인증서 설정
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/hyeondle.42.fr.key \
    -out /etc/ssl/certs/hyeondle.42.fr.crt \
    -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=hyeondle/CN=hyeondle.42.fr"

# nginx 설정 복사
COPY ./conf/nginx.conf /etc/nginx/sites-available/

# default 설정 삭제 후 심볼릭 링크 설정
RUN rm -f /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# 포트 443 열기
EXPOSE 443

# NGINX 실행
CMD ["nginx", "-g", "daemon off;"]
