#!/usr/bin/env bash
set -e

DRIVER_DIR="/driver"
OUTPUT_DIR="/output"
DRIVER_FILE="$DRIVER_DIR/postgresql.jar"
JDBC_URL="https://jdbc.postgresql.org/download/postgresql-42.7.3.jar"
SCHEMASPY_JAR="/usr/local/lib/schemaspy/schemaspy-app.jar"

echo "Checking PostgreSQL JDBC driver in $DRIVER_DIR"

if [ ! -f "$DRIVER_FILE" ]; then
    echo "Driver not found, downloading..."
    mkdir -p "$DRIVER_DIR"
    mkdir -p "$OUTPUT_DIR"
    wget -q -O "$DRIVER_FILE" "$JDBC_URL"
    echo "Download complete: $DRIVER_FILE"
else
    echo "Driver already present: $DRIVER_FILE"
fi

echo "Running SchemaSpy analysis..."
java -jar "$SCHEMASPY_JAR" \
    -t pgsql \
    -host postgres \
    -port 5432 \
    -db "${POSTGRES_DB}" \
    -s dwh \
    -u "${POSTGRES_USER}" \
    -p "${POSTGRES_PASSWORD}" \
    -dp "$DRIVER_FILE" \
    -o /output \
    -debug