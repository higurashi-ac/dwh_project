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
    dag_id='etl_dim_planning_slot',
    default_args=default_args,
    description='ETL for dim_planning_slot',
    schedule_interval='@hourly',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=['dwh', 'dimension'],
) as dag:

    load_dim = PostgresOperator(
        task_id='load_dim_planning_slot',
        postgres_conn_id='postgres_default',
        sql='sql/load_dim_planning_slot.sql',
    )

