# 기본 이미지로 Debian Bullseye를 사용합니다.
FROM debian:bullseye

# 패키지를 최신 상태로 업데이트하고 MariaDB 서버를 설치합니다.
RUN apt-get update && apt-get install -y mariadb-server

# 설정 파일을 MariaDB의 설정 디렉토리에 복사합니다.
COPY conf/ /etc/mysql/mariadb.conf.d/

# 초기화 스크립트를 적절한 위치에 복사합니다.
COPY tools/init-database.sh /usr/local/bin/

# 복사한 스크립트에 실행 권한을 부여합니다.
RUN chmod +x /usr/local/bin/init-database.sh

# MariaDB 데이터를 저장할 볼륨을 선언합니다.
VOLUME ["/var/lib/mysql"]

# MariaDB 서버가 사용하는 기본 포트인 3306을 열어둡니다.
EXPOSE 3306

# 컨테이너가 시작될 때 초기화 스크립트를 실행한 후 MariaDB 서버를 시작합니다.
CMD ["/usr/local/bin/init-database.sh"]
