#!/bin/bash
set -e

host="$1"
shift
cmd="$@"

until pg_isready -h "$host" -U "$POSTGRES_USER" -d "$POSTGRES_DB"; do
  echo "Waiting for Postgres at $host..."
  sleep 2
done

>&2 echo "Postgres is up — executing command"
exec $cmd