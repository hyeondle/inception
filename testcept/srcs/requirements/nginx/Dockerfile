# 기본 이미지로 Debian Bullseye를 사용합니다.
FROM debian:bullseye

# 패키지를 최신 상태로 업데이트하고 nginx를 설치합니다.
RUN apt-get update && apt-get install -y nginx openssl

# nginx 설정 파일을 복사합니다.
COPY conf/ /etc/nginx/conf.d/

# SSL 인증서 생성 스크립트를 복사하고 실행합니다.
COPY tools/generate-ssl.sh /tmp/
RUN bash /tmp/generate-ssl.sh

# 웹 서버가 사용하는 포트를 열어둡니다.
EXPOSE 443

# 컨테이너가 실행될 때 nginx를 시작합니다.
CMD ["nginx", "-g", "daemon off;"]
