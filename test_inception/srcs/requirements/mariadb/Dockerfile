# 기본 이미지 설정
FROM debian:bullseye

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y mariadb-server

# MariaDB 설정 파일 복사
COPY ./conf/my.cnf /etc/mysql/my.cnf

# MariaDB 시작
CMD ["mysqld"]