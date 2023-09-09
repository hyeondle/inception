# 기본 이미지로 Debian Bullseye를 사용
FROM debian:bullseye

# 패키지를 최신 상태로 업데이트하고 nginx를 설치
RUN apt-get update && apt-get install -y nginx openssl

# nginx 설정 파일을 복사
COPY conf/ /etc/nginx/conf.d/

# SSL 인증서 생성 스크립트를 복사하고 실행
COPY tools/generate-ssl.sh /tmp/
RUN bash /tmp/generate-ssl.sh

# 포트 개ㅏㅂㅇ
EXPOSE 443

# 컨테이너가 실행될 때 nginx를 시작
CMD ["nginx", "-g", "daemon off;"]
