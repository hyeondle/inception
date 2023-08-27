# Base image
FROM debian:bullseye

# Maintainer information
LABEL maintainer="hyeondle@42.fr"

# Install necessary packages and MariaDB
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y mariadb-server

# Copy the MariaDB configuration and init scripts
COPY ./conf/my.cnf /etc/mysql/my.cnf
COPY ./tools/init.sh /usr/bin/

# Set permissions for scripts
RUN chmod +x /usr/bin/init.sh

# Environment variables
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=wordpress
ENV MYSQL_USER=hyeondle
ENV MYSQL_PASSWORD=password

# Expose port
EXPOSE 3306

# Start MariaDB
CMD ["init.sh"]