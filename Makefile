make:
	mkdir -p /home/asokolov/data
	mkdir -p /home/asokolov/data/mariadb
	mkdir -p /home/asokolov/data/wordpress
	cd /home/asokolov/inception/srcs && docker-compose up -d --build

down:
	cd /home/asokolov/inception/srcs && docker-compose down

clean:	down
	sudo docker system prune -a -f
	sudo docker volume rm srcs_wordpress_data srcs_mariadb_data || true

fclean:	clean
	@if [ -d /home/asokolov/data ]; then \
		sudo rm -rf /home/asokolov/data; \
	fi

re:	fclean make

.PHONY: make down clean fclean re
