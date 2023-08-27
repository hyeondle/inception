# 기본 이미지 선택
FROM debian:bullseye

# 환경 변수 설정 (비밀번호는 나중에 .env 파일에서 설정하도록 추천합니다.)
ENV WP_DB_HOST=db:3306
ENV WP_DB_USER=wordpressuser
ENV WP_DB_PASSWORD=password
ENV WP_DB_NAME=wordpress

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    wget \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-gd \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-zip \
    && rm -rf /var/lib/apt/lists/*

# 워드프레스 다운로드 및 설치
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xvzf latest.tar.gz && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html/wordpress

# WordPress 설정 파일 복사
COPY conf/wp-config.php /var/www/html/wp-config.php

# PHP-FPM 설정 파일 복사
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
# 권한 및 소유자 조정
RUN chown www-data:www-data /var/www/html/wp-config.php && \
    chmod 644 /var/www/html/wp-config.php
# PHP-FPM 실행
CMD ["php-fpm7.4", "-F"]
