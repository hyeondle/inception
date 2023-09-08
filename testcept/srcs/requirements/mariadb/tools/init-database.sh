#!/bin/bash

# 환경 변수에서 데이터베이스 설정 정보를 가져옵니다.
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

mkdir -p /var/run/mysqld/
chown -R mysql:mysql /var/run/mysqld/

# 데이터베이스 초기화
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysqld --initialize-insecure
    mysqld &

# 서버가 완전히 시작될 때까지 대기
sleep 10

# 데이터베이스와 사용자를 초기화합니다.
mysql -u root <<-EOSQL
CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOSQL
fi

# mysqld를 포그라운드에서 실행
exec mysqld
