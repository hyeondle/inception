# 기본 이미지 설정
FROM debian:bullseye

# NGINX 및 SSL 설정을 위한 필요 패키지 설치
RUN apt-get update && apt-get install -y nginx openssl

# SSL 설정
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=IT Department/CN=hyeondle.42.fr" -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

# NGINX 설정 파일 복사
COPY ./conf/default.conf /etc/nginx/sites-available/default

# NGINX 시작
CMD ["nginx", "-g", "daemon off;"]
