.PHONY: docker-build docker-run docker-postgres docker-compose-up-postgres-container docker-compose-down-postgres-container docker-compose-up-students-api docker-compose-down-students-api

# Build the Docker image
docker-build:
	docker build --no-cache --platform linux/amd64 -t student-api:1.0.0 .

# Start the postgres-container service
docker-compose-up-postgres-container:
	docker compose up postgres-container -d

# Start the students-api service
docker-compose-up-students-api:
	docker compose up -d students-api


