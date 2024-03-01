name = inception
all:
	@printf "Launch configuration ${name}...\n"
	@bash srcs/requirements/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

start:
	@docker-compose -f ./srcs/docker-compose.yml start

stop:
	@docker-compose -f ./srcs/docker-compose.yml stop

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env down

re: down
	@printf "Rebuild configuration ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file srcs/.env up -d --build

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a

fclean:
	@printf "Total clean of all configurations docker\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker volume rm srcs_db-volume srcs_wp-volume
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data

.PHONY	: all start stop build down re clean fclean
