-- Connect to your local Postgres DW (docker exec or VS Code SQL client)
\c postgres
CREATE DATABASE dev_dwh;

-- Connect to the DW
\c dev_dwh

-- Create staging schema
CREATE SCHEMA IF NOT EXISTS stg;

--docker exec -i postgres psql -U postgres -d dev_dwh -f /docker-entrypoint-initdb.d/utils/test.sql  