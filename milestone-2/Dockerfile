# Stage 1: Build
FROM node:lts-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --only=prod
COPY . .

# Stage 2: Production
FROM alpine:3
RUN apk add --no-cache nodejs npm postgresql-client
WORKDIR /app
COPY --from=builder /app /app
RUN chmod +x wait-for-postgres.sh
ENV NODE_ENV=production
EXPOSE 3000
CMD ["sh", "-c", "/app/wait-for-postgres.sh && npm start"]


 