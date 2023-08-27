# Base image
FROM debian:bullseye

# 환경변수 설정 (환경 변수는 .env 파일에서 오게 됩니다)
ENV DOMAIN_NAME=hyeondle.42.fr
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=hyeondle
ENV MYSQL_PASSWORD=user_password

# Install necessary packages for WordPress and PHP-FPM
RUN apt-get update && apt-get install -y \
    wordpress \
    php-fpm \
    php-mysql \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Configure WordPress
COPY ./conf/wp-config.php /var/www/html/wordpress/wp-config.php
RUN chown -R www-data:www-data /var/www/html/wordpress

# Expose port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
