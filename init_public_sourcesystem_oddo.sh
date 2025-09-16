#!/bin/bash
# load_source_system.sh
# Loads all SQL files from ./datadumps into dev_dwh.public

DB_NAME="dev_dwh"
DB_USER="postgres"
SCHEMA="public"
SQL_DIR="./data_dumps"

# Optional: reset public schema
# docker exec -i postgres psql -U $DB_USER -d $DB_NAME -c "DROP SCHEMA $SCHEMA CASCADE; CREATE SCHEMA $SCHEMA;"

#hedha Create tables to launch beforehand
 docker exec -i postgres psql -U postgres -d dev_dwh -v schema=public -f /docker-entrypoint-initdb.d/create.sql

# Loop through all .sql files and load them
for sql_file in $SQL_DIR/*.sql; do
    echo "Loading $sql_file into $DB_NAME.$SCHEMA..."
    docker exec -i postgres psql -U $DB_USER -d $DB_NAME -v schema=$SCHEMA -f /docker-entrypoint-initdb.d/$(basename $sql_file)
done

echo "All SQL files loaded into $DB_NAME.$SCHEMA."
