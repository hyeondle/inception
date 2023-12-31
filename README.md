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

### Dockerfile

"A Docker container that contains MariaDB only without nginx."구문에 설마?할 수 있지만

apt-get install mariadb만 해서는 nginx가 같이 깔리지 않는다. 물론 mariadb도커 이미지를 불러와도 그렇다.

따라서 그냥 설치하면 된다.

다만, 여기서 mariadb-server을 설치하기로 결정했는데, 그 이유는

이 과제에서 요구하는 내용이 단순한 db연결로의 기능만 구현하면 된다는 점,

용량이 작게 제한되어있는 클러스터 맥의 특성상 최대한 용량을 줄여보려는 노력,

설치 내용이 적기때문에 오류발생시 처리가 더 간편하다는 점 때문이다.

### conf file

mariadb에서 설정파일을 로드할 때, 알파벳순으로 로드하여 세팅이 덮어씌어진다.

따라서 내가 default.cnf에 여러가지 세팅을 해 두더라도, 후에 50-server.cnf라는 파일에서

그 설정들이 초기화 될 가능성이 있다는 것이다.

따라서 해당 위험을 없애기 위해 default.cnf가 아닌 50-server.cnf를 직접 수정하여 덮어씌우는 방법으로 작성한다.

### init file

모든 기본적인 세팅이 완료된 후, 초기 실행상태에서는 mariadb의 데이터베이스가 생성되어있지 않은 상태다.

따라서 mysql_install_db를 통해 데이터베이스를 만들고, wordpress에서 접근할 수 있도록 데이터베이스 그룹과

유저를 추가해 주어야 한다.

주의점은 PID를 잘 생각해야 한다는 것이다. 

(데이터베이스를 만들 경우 mysql을 한번 실행하는데, 이 상태에서 마무리할 경우 또 하위의 mysql이 실행되어

PID가 1이 아닌 상황이 발생해 추후 에러가 발생할 가능성이 높아진다. 따라서, 데이터베이스 초기화 후 선실행한 mysql을 종료해야한다)

## Wordpress(+PHP)

알아두면 좋은 내용 : 

1. 동적 컨텐츠 vs 정적 컨텐츠
2. CGI vs FastCGI

워드프레스의 경우 .php로 대부분 관리되는, 즉 대부분 데이터베이스와 계속 데이터를 주거니 받거니 하며 동적으로 컨텐츠를 제공하는 형태이므로 nginx와는 fastcgi를 통해 통신할 예정이다 (nginx에서 서술함)

phar = PHP Archieve

: PHP로 작성된 프로젝트를 하나의 파일로 압축(아카이브)하는 포맷. PHAR 파일은 실행 가능하며, 여러 PHP 파일을 포함할 수 있다.

### Dockerfile

왜 Wordpress가 아닌 wp-cli를 설치?

-> phar을 이용해 단순한 명령어만으로도 여러가지 명렁 수행이 가능 (플러그인 설치, 데이터베이스 관리, 페이지 관리 등등)

왜 WORKDIR로 경로를 바꿈?

-> wp가 설치된 위치로 경로를 옮기지 않을 시, wp관련 명령어 실행 중 설치과정에 오류가 발생하는 경우가 발견됨. 따라서 wordpress를 관리하는 위치로 경로를 옮기기로 함.

### 설정 파일

먼저, 워드프레스의 경우 nginx를 통해 들어오는 신호에 대해 반응할 예정이며, 포트는 9000번만을 통해 통신하기로 결정되어 있으므로

설정 파일에 listen = 0.0.0.0:9000이 추가되어 있어야 한다.

user, group은 FPM 작업자 프로세스가 실행될 떄 사용할 이름이며,

pm은 프로세스 매니저를 의미한다. 여기서 dynamic은 FPM이 자동으로 자식 프로세스의 수를 조절하게 된다는 것인데

기본적으로 주어지는 세팅과 크게 다르지 않게 설정하였다.

chdir = / 을 해준 이유는 wp-cli를 통해 설치할 때, 경로가 변경되어 있으므로, FPM이 실행될 때 시작 경로를 루트 디렉토리로 바꿔주는 역할이다.


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

추가로, 정상적으로 빌드가 완료되었을 시,

curl hyeondle.42.fr:80

curl hyeondle.42.fr:443

으로 http와 https연결 확인이 가능하다.

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

PID 1 의 의미

: 도커 컨테이너 하나당 하나의 프로세스라는 원칙을 생각한다면, PID 1 의 의미를 이해할 수 있다.

