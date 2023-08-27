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
