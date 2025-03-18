FRONTEND_IMAGE=nginx-template-app
BACKEND_IMAGE=nginx-template-server
NGINX_IMAGE=nginx-template-nginx
FRONTEND_PORT=5173
BACKEND_PORT=5000
NGINX_PORT=8080

.DEFAULT_GOAL := help

define check-image
	@if [ -z "$$(docker images -q "$(strip $(1)):$(strip $(2))")" ]; then \
		echo "Error: $(1) image with '$(2)' tag not found!. Please run 'make $(2)-build' again to build missing image."; exit 1; \
	fi
endef


start-app-dev:
	$(call check-image, $(FRONTEND_IMAGE), dev)
	@echo "Starting frontend (dev)..."
	docker run -i -p $(FRONTEND_PORT):3000 -v ${PWD}/frontend:/app -v /app/node_modules $(FRONTEND_IMAGE):dev
	@echo "Frontend (dev) is running on port $(FRONTEND_PORT)"

start-app-dev-d:
	$(call check-image, $(FRONTEND_IMAGE), dev)
	@echo "Starting frontend (dev)..."
	docker run -i -d -p $(FRONTEND_PORT):3000 -v ${PWD}/frontend:/app -v /app/node_modules $(FRONTEND_IMAGE):dev
	@echo "Frontend (dev) is running on port $(FRONTEND_PORT)"

start-app-prod:
	$(call check-image, $(FRONTEND_IMAGE), prod)
	@echo "Starting frontend (prod)..."
	docker run -i -d -p $(FRONTEND_PORT):3000 -v ${PWD}/frontend:/app -v /app/node_modules $(FRONTEND_IMAGE):prod
	@echo "Frontend finished building."

start-app-prod-d:
	$(call check-image, $(FRONTEND_IMAGE), prod)
	@echo "Starting frontend (prod)..."
	docker run -i -d -p $(FRONTEND_PORT):3000 -v ${PWD}/frontend:/app -v /app/node_modules $(FRONTEND_IMAGE):prod
	@echo "Frontend finished building."

start-server-dev:
	$(call check-image, $(BACKEND_IMAGE), dev)
	@echo "Starting server (dev)..."
	docker run -i -p $(BACKEND_PORT):5000 -v ${PWD}/backend:/app -v /app/node_modules $(BACKEND_IMAGE):dev
	@echo "Server (dev) is running on port $(BACKEND_PORT)"

start-server-dev-d:
	$(call check-image, $(BACKEND_IMAGE), dev)
	@echo "Starting server (dev)..."
	docker run -i -d -p $(BACKEND_PORT):5000 -v ${PWD}/backend:/app -v /app/node_modules $(BACKEND_IMAGE):dev
	@echo "Server (dev) is running on port $(BACKEND_PORT)"

start-server-prod:
	$(call check-image, $(BACKEND_IMAGE), prod)
	@echo "Starting server (prod)..."
	docker run -i -p $(BACKEND_PORT):5000 -v ${PWD}/backend:/app -v /app/node_modules $(BACKEND_IMAGE):prod
	@echo "Server (prod) is running on port $(BACKEND_PORT)"

start-server-prod-d:
	$(call check-image, $(BACKEND_IMAGE), prod)
	@echo "Starting server (prod)..."
	docker run -i d -p $(BACKEND_PORT):5000 -v ${PWD}/backend:/app -v /app/node_modules $(BACKEND_IMAGE):prod
	@echo "Server (prod) is running on port $(BACKEND_PORT)"

stop-app-dev:
	@echo "Stopping frontend..."
	docker ps -q --filter ancestor=$(FRONTEND_IMAGE) | xargs -r docker stop
	@echo "Frontend stopped."

stop-app-prod:
	@echo "Stopping frontend..."
	docker ps -q --filter ancestor=$(FRONTEND_IMAGE) | xargs -r docker stop
	@echo "Frontend stopped."

stop-server-dev:
	@echo "Stopping server..."
	docker ps -q --filter ancestor=$(BACKEND_IMAGE) | xargs -r docker stop
	@echo "Server stopped."

stop-server-prod:
	@echo "Stopping server..."
	docker ps -q --filter ancestor=$(BACKEND_IMAGE) | xargs -r docker stop
	@echo "Server stopped."

build-dev:
	docker compose build

build-prod:
	docker compose -f docker-compose.yml build

clean-all:
	docker compose down --rmi all --volumes --remove-orphans

clean-all-f:
	docker compose down --rmi all --volumes --remove-orphans
	docker rm -f $$(docker ps -a -q)

clean-containers:
	docker compose down --remove-orphans

clean-containers-f:
	docker compose down --remove-orphans
	docker rm -f $$(docker ps -a -q)

down:
	docker compose down

down-prod: check-images-prod
	@echo "Stopping production containers..."
	docker compose -f docker-compose.yml down
	@echo "Production has stopped"

down-dev: check-images-dev
	@echo "Stopping development containers..."
	docker compose -f docker-compose.override.yml down
	@echo "Development has stopped"

up:
	docker compose up

up-prod: check-images-prod
	@echo "Starting production containers..."
	docker compose -f docker-compose.yml up
	@echo "Production is running!"

up-dev: check-images-dev
	@echo "Starting development containers..."
	docker compose -f docker-compose.override.yml up
	@echo "Development is running!"

check-images-prod:
	@if [ -z "$$(docker images -q $(FRONTEND_IMAGE):prod)" ]; then \
		echo "Error: Frontend image that 'prod' not found!. Please run 'make prod-build' again to build missing image."; exit 1; \
	fi
	@if [ -z "$$(docker images -q $(BACKEND_IMAGE):prod)" ]; then \
		echo "Error: Backend image with that 'prod' not found!. Please run 'make prod-build' again to build missing image."; exit 1; \
	fi
	@if [ -z "$$(docker images -q $(NGINX_IMAGE):prod)" ]; then \
		echo "Error: Nginx image with that 'prod' not found!. Please run 'make prod-build' again to build missing image."; exit 1; \
	fi
check-images-dev:
	@if [ -z "$$(docker images -q $(FRONTEND_IMAGE):dev)" ]; then \
		echo "Error: Frontend image 'dev' tag not found!. Please run 'make dev-build' again to build missing image."; exit 1; \
	fi
	@if [ -z "$$(docker images -q $(BACKEND_IMAGE):dev)" ]; then \
		echo "Error: Backend image with 'dev' tag not found!. Please run 'make dev-build' again to build missing image."; exit 1; \
	fi
	@if [ -z "$$(docker images -q $(NGINX_IMAGE):dev)" ]; then \
		echo "Error: Nginx image with 'dev' tag not found!. Please run 'make dev-build' again to build missing image."; exit 1; \
	fi
help:
	@echo "Makefile Commands:"
	@echo ""
	@echo "  Development:"
	@echo "    make start-app-dev       - Start the frontend container in development mode"
	@echo "    make start-server-dev    - Start the backend container in development mode"
	@echo "    make start-app-dev-d       - Start the frontend container in development detached mode"
	@echo "    make start-server-dev-d    - Start the backend container in development detached mode"	
	@echo "    make stop-app-dev        - Stop the frontend container (dev)"
	@echo "    make stop-server-dev     - Stop the backend container (dev)"
	@echo ""
	@echo "  Production:"
	@echo "    make start-app-prod      - Start the frontend container in production mode"
	@echo "    make start-server-prod   - Start the backend container in production mode"
	@echo "    make start-app-prod-d      - Start the frontend container in production detached mode"
	@echo "    make start-server-prod-d   - Start the backend container in production detached mode"
	@echo "    make stop-app-prod       - Stop the frontend container (prod)"
	@echo "    make stop-server-prod    - Stop the backend container (prod)"
	@echo ""
	@echo "  Build & Cleanup:"
	@echo "    make build-dev           - Build all services for development"
	@echo "    make build-prod          - Build all services for production"
	@echo "    make clean-all           - Remove all containers, images, and volumes"
	@echo "    make clean-all-f         - Force remove all containers, images, and volumes"
	@echo "    make clean-containers    - Remove all containers"
	@echo "    make clean-containers-f  - Force remove all containers"
	@echo ""
	@echo "  Docker Compose Control:"
	@echo "    make up                  - Start all services using Docker Compose"
	@echo "    make down                - Stop and remove all containers"
	@echo "    make up-dev              - Start development services with Docker Compose"
	@echo "    make down-dev            - Stop development services with Docker Compose"
	@echo "    make up-prod             - Start production services with Docker Compose"
	@echo "    make down-prod           - Stop production services with Docker Compose"
	@echo ""
	@echo "  Image Checks:"
	@echo "    make check-images-dev    - Check if development images exist"
	@echo "    make check-images-prod   - Check if production images exist"
