#!/bin/sh

# Wait until PostgreSQL is ready
echo "Waiting for PostgreSQL to be ready..."

until pg_isready -h "$POSTGRES_HOST" -p 5432 -U "$POSTGRES_USER"; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done



# Run migration after PostgreSQL is ready
if npm run migrate; then
   echo "Postgres is up - executing migration"
   echo "Migration completed successfully"
else
  >&2 echo "Migration failed"
  exit 1
fi
