# inception
practice 42's inception

# 진행 순서

환경설정
: VirtualBox에 가상 운영체제를 돌림
: 도커와 도커 컴포즈 설치 및 sudo권한 설정
: 도메인 설정 (/etc/hosts) 및 DNS 설정 (127.0.0.1 -> 8.8.8.8)

1. 각 디렉토리 생성
2. 각 서비스(NGINX, WordPress, MariaDB)에 대한 Dockerfile 작성
3. 각 서비스의 설정 작성
   - NGINX : Https, TLSv1.2 or TLSv1.3 포함
   - WordPress & MariaDB : 초기 설정 스크립트, SQL파일 준비. 두 사용자(하나는 관리자)를 생성하는 부분 포함
4. 각 서비스 및, docker-compose.yml에 사용될 환경변수를 저장하는 .env 파일 작성
5. 구성된 서비스들을 유기적으로 연결할 docker-comse.yml 작성 (각 서비스와 볼륨, 네트워크를 정의, 서비스 간 의존성 설정. 도커 네트워크 구성)
6. Makefile작성 

# 1. 각 디렉토리 생성

## 최상위 디렉토리 생성
mkdir -p ./Inception/srcs/requirements/{bonus,mariadb,nginx,tools,wordpress}

## mariadb, nginx, wordpress에 필요한 하위 디렉토리 생성
mkdir -p ./Inception/srcs/requirements/mariadb/{conf,tools}
mkdir -p ./Inception/srcs/requirements/nginx/{conf,tools}
mkdir -p ./Inception/srcs/requirements/wordpress/{conf,tools}


# 2. 각 서비스에 대한 Dockerfile 작성

도커 네트워크를 구성할 때, 각 서비스나 컨테이너가 어떠한 의존성을 가지고 있는지 파악하는 것이 중요.
현 과제에서는 NGINX, WordPress, MariaDB임.

MariaDB : 데이터베이스는 다른 서비스에 데이터를 제공하므로 가장 먼저 시작.
WordPress : MariaDB에 의존적이므로 MariaDB가 준비된 후에 시작되어야 함
NGINX : NGINX는 사용자의 요청을 WordPress로 전달하므로, WordPress가 준비된 후 시작되어야 함.

즉, MariaDB->WordPress->NGINX순서로 만드는 것이 좋음.

각 Dockerfile을 만들 때.

MariaDB : MariaDB 기반 이미지 생성, 데이터베이스 설정과 관련된 초기화 스크립트 or SQL 파일을 포함시킨다.
WordPress : PHP-FPM 환경을 설정. MariaDB에 연결하기 위한 설정을 포함
NGINX : NGINX 설정. SSL/TLS 설정 및 WordPress로의 프록시 설정을 구성.

이후, docker-compose.yml에서 이러한 의존성을 depends_on 키워드로 정의가 가능 (없어도 상관은 없음)

# 그 외
https://nickjanetakis.com/blog/benchmarking-debian-vs-alpine-as-a-base-docker-image
를 참고하여, debian을 기준으로 사용하기로 결정함. 
