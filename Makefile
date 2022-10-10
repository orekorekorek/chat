%:
	@:

test_alias=test t
test:
	docker-compose run --rm app bundle exec rspec $(filter-out $(test_alias), $(MAKECMDGOALS))

console:
	docker-compose run --rm app bundle exec rails c

bash:
	docker-compose run --rm app bash

attach:
	docker attach instatalk-action-cable-app-1

restart:
	docker restart instatalk-action-cable-app:latest

start:
	docker-compose up 
