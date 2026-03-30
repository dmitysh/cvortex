.PHONY: run
run:
	go run cmd/hr-helper/main.go

.PHONY: up
up:
	docker-compose up --build hr-helper

.PHONY: up-dev
up-dev:
	docker-compose up --build hr-helper-dev

.PHONY: deploy
deploy:
	./deploy.sh . dimasik@158.160.118.46:/home/dimasik/app ~/.ssh/yc_id_ed25519

.PHONY: migrate-up
migrate-up:
	goose -dir ./migrations postgres "postgres://hr-helper:ycRh%3DC9PHO%3B~k%3C8fd%5D-c'Zp%2B09%3A1J%24%60%7DUf2%7C@rc1d-mhk3cqemvsff343j.mdb.yandexcloud.net:6432/hr-helper" up
