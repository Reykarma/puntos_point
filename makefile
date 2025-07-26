COMPOSE = docker-compose

.PHONY: build up down restart logs db-create db-migrate db-reset db-seed bash rspec sidekiq

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) down
	$(COMPOSE) up

logs:
	$(COMPOSE) logs -f

bash:
	$(COMPOSE) run --rm web bash

db-create:
	$(COMPOSE) run --rm web rails db:create

db-migrate:
	$(COMPOSE) run --rm web rails db:migrate

db-reset:
	$(COMPOSE) run --rm web rails db:drop db:create db:migrate

db-seed:
	$(COMPOSE) run --rm web rails db:seed

rspec:
	$(COMPOSE) run --rm web rspec

sidekiq:
	$(COMPOSE) run --rm web bundle exec sidekiq
