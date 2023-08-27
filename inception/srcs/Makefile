# Makefile

all: build up

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

re: down all

.PHONY: all build up down logs ps re
