# 기본 이미지로 Debian Bullseye를 사용합니다.
FROM debian:bullseye

# 패키지를 최신 상태로 업데이트하고 필요한 패키지들을 설치합니다.
RUN apt-get update && apt-get install -y php-fpm php-mysql wget mariadb-client

# WordPress의 PHP 설정을 복사합니다.
COPY conf/php-fpm.conf /etc/php/7.4/fpm/pool.d/www.conf

# WordPress CLI를 다운로드 및 설치합니다.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# WordPress 설치 스크립트를 복사합니다.
COPY tools/wordpress-setup.sh /tmp/

# 스크립트 실행
CMD ["bash", "/tmp/wordpress-setup.sh"]
