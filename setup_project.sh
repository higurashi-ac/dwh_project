#!/bin/bash
set -e

mkdir -p dags sql

# List of dimensions
dims=(
  partner
  employee
  sale_order
  sale_order_line
  purchase_order
  purchase_order_line
  planning_slot
  payment_justify
  account_move
  account_journal
)

for dim in "${dims[@]}"; do
    # DAG
    dag_file="dags/etl_dim_${dim}.py"
    if [ ! -f "$dag_file" ]; then
        cat <<EOF > "$dag_file"
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='etl_dim_${dim}',
    default_args=default_args,
    description='ETL for dim_${dim}',
    schedule_interval='@hourly',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=['dwh', 'dimension'],
) as dag:

    load_dim = PostgresOperator(
        task_id='load_dim_${dim}',
        postgres_conn_id='postgres_public',
        sql='sql/load_dim_${dim}.sql',
    )
EOF
        echo "Created DAG: $dag_file"
    fi

    # SQL
    sql_file="sql/load_dim_${dim}.sql"
    if [ ! -f "$sql_file" ]; then
        cat <<EOF > "$sql_file"
-- =====================================================
-- Dimension table for ${dim}
-- =====================================================
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_${dim} (
    ${dim}_sk SERIAL PRIMARY KEY,
    ${dim}_id INT UNIQUE,  -- BK from Odoo
    -- TODO: add your business columns here
    stg_loaded_at TIMESTAMP,
    stg_batch_id VARCHAR
);

-- =====================================================
-- FULL LOAD (truncate + reload)
-- Use this for initial backfill
-- =====================================================
-- TRUNCATE dwh.dim_${dim};

-- INSERT INTO dwh.dim_${dim} (
--     ${dim}_id,
--     -- TODO: add your business columns here
--     stg_loaded_at,
--     stg_batch_id
-- )
-- SELECT
--     s.id AS ${dim}_id,
--     -- TODO: map staging columns here
--     s.stg_loaded_at,
--     s.stg_batch_id
-- FROM stg.${dim} s;

-- =====================================================
-- INCREMENTAL UPSERT
-- Use this for near real-time updates
-- =====================================================
INSERT INTO dwh.dim_${dim} (
    ${dim}_id,
    -- TODO: add your business columns here
    stg_loaded_at,
    stg_batch_id
)
SELECT
    s.id AS ${dim}_id,
    -- TODO: map staging columns here
    s.stg_loaded_at,
    s.stg_batch_id
FROM stg.${dim} s
ON CONFLICT (${dim}_id) DO UPDATE
SET
    -- TODO: update business columns here
    stg_loaded_at = EXCLUDED.stg_loaded_at,
    stg_batch_id = EXCLUDED.stg_batch_id;
EOF
        echo "Created SQL: $sql_file"
    fi
done

echo "✅ Project structure with SK + BK, FULL + INCREMENTAL templates ready"
