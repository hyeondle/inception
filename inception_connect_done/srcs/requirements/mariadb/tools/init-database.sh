#!/bin/bash

# 환경 변수에서 데이터베이스 설정 정보를 불러옴
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_DATABASE=${MYSQL_DATABASE}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

mkdir -p /var/run/mysqld/
chown -R mysql:mysql /var/run/mysqld/
chㅐㅈn -R mysql:mysql /var/lib/mysql/
# 데이터베이스 초기화
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql/
    mysqld &
    MYSQL_PID=$!
# 서버가 완전히 시작될 때까지 대기
sleep 10

# 데이터베이스와 사용자를 초기화
mysql -u root <<-EOSQL
CREATE DATABASE $MYSQL_DATABASE;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOSQL
    kill -TERM $MYSQL_PID
    wait $MYSQL_PID
fi

# mysqld를 포그라운드에서 실행
exec mysqld
