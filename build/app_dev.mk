.PHONY: network
network:
	@docker network create --driver bridge some-network

.PHONY: up
up:
	@echo "::: building dev environment in port $(APP_PORT)"
	@docker-compose -f docker-compose.yml up

.PHONY: down
down:
	@echo " ::: tear down dev environment"
	@docker-compose -f docker-compose.yml down

.PHONY: debug
debug:
	@echo "::: debugging dev environment"
	@docker-compose -f docker-compose-debug.yml up

.PHONY: debug-down
debug-down:
	@echo "::: tear down debug dev environment"
	@docker-compose -f docker-compose-debug.yml down
