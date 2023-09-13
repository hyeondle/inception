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

# 1. 기본 세팅

## 최상위 디렉토리 생성
mkdir -p ./Inception/srcs/requirements/{bonus,mariadb,nginx,tools,wordpress}

## mariadb, nginx, wordpress에 필요한 하위 디렉토리 생성
mkdir -p ./Inception/srcs/requirements/mariadb/{conf,tools}

mkdir -p ./Inception/srcs/requirements/nginx/{conf,tools}

mkdir -p ./Inception/srcs/requirements/wordpress/{conf,tools}

## Virtualbox 에서 공유폴더 사용 방법
mount -t vboxsf ${공유폴더} ${가상머신 내 폴더}

## Docker 설치
sudo apt update

sudo apt install -y curl

curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh

sudo usermod -aG docker $USER

마지막 줄은 루트가 아닌 사용자도 도커를 사용하도록 하는 명령어이므로, sudo나 root로 진행시 입력하지 않아도 된다

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

# 3. 각 서비스에 대한 설정파일 및 스크립트 작성

이번 과제에서는 DockerHub상에 존재하는 이미지를 불러오는 것이 아닌,

서비스중인 최신버전 이전의 버전의 Debian 혹은 Alpine의 이미지로부터 시작해 하나하나 이미지를 작성하여야 한다.

(For performance matters, the containers must be built either from the penultimate stable version of Alpine or Debian)

즉, Dockerfile에서 FROM mariadb 와 같은 명령어는 사용 불가능 하며, FROM debian:bullseye(현 최신버전이 12, bookworm)와 같은방식으로

raw 이미지를 불러와 하나의 가상머신처럼 만든 뒤, 필요한 패키지만을 설치, 세팅하도록 하는 것이다.

각각의 과제 요구사항에 맞게 필요한 최소한의 패키지만을 설치한 뒤, 추가적인 세팅은 미리 세팅파일을 만들어 두어 옮기거나

스크립트 파일을 이용해 명령어를 입력하도록 한다.

## MariaDB

## Wordpress(+PHP)

## NGINX

# 4. docker-compose.yml 작성

만들어둔 3개의 도커파일을 통해 docker-compose로 이 이미지들을 동일 네트워크상에 두고, 과제에서 요구하는 볼륨 설정 및 기타 설정들을 수행한다.

## Volume 경로 작성 및 권한 설정

해당 과제에서 요구하는 Volume의 위치가 /home/login/data (login은 자신의 id로 변경)인데,

Makefile단계에서 조건문을 이용하여 폴더를 생성 및 삭제해도 되지만, 권한문제가 발생할 수 있으므로 먼저

해당 위치에 db/, wordpress/ 폴더를 생성해 둔다.

물론, docker-compose.yml에서 'device:'명령어를 통해 각각의 볼륨의 위치를 지정해 주는것도 필요하다. 

# 5. Makefile 작성 및 실행

'docker-compose'가 아닌 'docker compose'이다.

docker compose를 사용하여 빌드하도록 명령어를 구성하고 실행해 본다.

# 6. 로그 확인 및 수정

에러 발생시 로그를 확인하며 수정, 또한 기타 이상한 작동이 발견됬을 때 로그를 확인하여 빠른 원인파악이 가능하다.

docker logs $(container_name)로 확인 가능하다.

그 외에, 각 컨테이너간 연결을 확인하고 싶다면 각 컨테이너에

apt-get install curl

을 통해 curl을 설치한 후, 컨테이너 외부에서

docker exec -it $(container1) curl $(container2)를 통해 확인 가능하다.

포트 지정은 $(container2):$(portnumber)로 가능하다.


# 그 외
https://nickjanetakis.com/blog/benchmarking-debian-vs-alpine-as-a-base-docker-image
를 참고하여, debian을 기준으로 사용하기로 결정함. 

Debian vs. Alpine:

데비안(Debian)과 알파인(Alpine) 이 두 배포판의 차이점은?

크기: Alpine은 경량화된 리눅스 배포판으로, 컨테이너 환경에서 최소한의 리소스로 실행될 수 있도록 설계되었다. 따라서 이미지 크기가 매우 작음.

패키지 관리자: Alpine은 apk 패키지 관리자를 사용하는 반면, Debian은 apt 패키지 관리자를 사용.

안정성과 호환성: Debian은 오랜 기간동안 안정성으로 알려져 왔고, 광범위한 패키지와 라이브러리를 지원함. 즉, Alpine은 경량화되어 있기 때문에 일부 특정 라이브러리나 패키지가 빠져 있을 수 있음.

Debian 버전:
"for performance matters, the containers must be built either from the penultimate stable version of Debian"라는 요구 사항이 있으므로, 현재의 최신 버전이 Debian 12라면, 이전의 안정된 버전인 Debian 11(Bullseye)을 사용해야 함. (buster이 아님)

예시 구성도

외부 : www

컴퓨터 호스트 : db(volume), wordpress(volume)

도커 네트워크(컴퓨터 호스트 안에 포함) : containerDB(mariadb, image docker), containerWordPress+PHP(wordpress, image docker), containerNGINX(nginx, image docker)

도커 네트워크간 연결 구성 :

containerDB <-> db

containerDB <-> ContainerWordPress+PHP (port 3306)

ContainerWordPress+PHP <-> wordpress

ContainerWordPress+PHP <-> ContainerNGINX (port 9000)

ContainerNGINX <-> wordpress

ContainerNGINX <-> www (port 442)

<-> : link network



