.PHONY: docker-build  docker-postgres  docker-run


# Build the Docker image
docker-build:
	docker build --no-cache --platform linux/amd64 -t student-api:1.0.0 .

# Run the PostgreSQL container
docker-postgres:
	docker run --name postgres-container --env-file .env -p 5431:5432 -v postgres-data:/var/lib/postgresql/data -d postgres:16

# Run the Docker container for the application
docker-run:  
	docker run -d  --name student-api-container --env-file .env --link postgres-container:postgres-container -p 3000:3000 student-api:1.0.0


