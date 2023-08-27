mkdir -p srcs/requirements/mariadb/conf srcs/requirements/mariadb/tools
mkdir -p srcs/requirements/nginx/conf srcs/requirements/nginx/tools
mkdir -p srcs/requirements/wordpress
touch srcs/docker-compose.yml srcs/.env
touch srcs/requirements/mariadb/Dockerfile srcs/requirements/mariadb/.dockerignore
touch srcs/requirements/nginx/Dockerfile srcs/requirements/nginx/.dockerignore
touch srcs/requirements/wordpress/Dockerfile