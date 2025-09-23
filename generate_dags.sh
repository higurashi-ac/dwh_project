#!/bin/bash

# List of dimension names
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

# Create dags folder if it doesn't exist
mkdir -p dags

# Loop through dimensions and create DAG files
for dim in "${dims[@]}"; do
    dag_file="dags/etl_dim_${dim}.py"
    cat > "$dag_file" <<EOL
from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.models import Variable

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

load_mode = Variable.get("load_mode_dim_${dim}", default_var="INCREMENTAL")

with DAG(
    'etl_dim_${dim}',
    default_args=default_args,
    description='ETL DAG for dim_${dim}',
    schedule_interval='*/10 * * * *',
    start_date=datetime(2025, 9, 16),
    catchup=False,
    tags=['dwh', 'dimension'],
) as dag:

    if load_mode.upper() == "FULL":
        full_load = PostgresOperator(
            task_id='full_load_dim_${dim}',
            postgres_conn_id='postgres_public',
            sql='sql/load_dim_${dim}.sql',
        )
    else:
        incremental_upsert = PostgresOperator(
            task_id='incremental_upsert_dim_${dim}',
            postgres_conn_id='postgres_public',
            sql='sql/load_dim_${dim}.sql',
        )
EOL
done

echo "All DAG files generated in ./dags folder."
