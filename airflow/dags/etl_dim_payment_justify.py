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

load_mode = Variable.get("load_mode_dim_payment_justify", default_var="INCREMENTAL")

with DAG(
    'etl_dim_payment_justify',
    default_args=default_args,
    description='ETL DAG for dim_payment_justify',
    schedule_interval='*/10 * * * *',
    start_date=datetime(2025, 9, 16),
    catchup=False,
    tags=['dwh', 'dimension'],
) as dag:

    if load_mode.upper() == "FULL":
        full_load = PostgresOperator(
            task_id='full_load_dim_payment_justify',
            postgres_conn_id='postgres_default',
            sql='sql/load_dim_payment_justify.sql',
        )
    else:
        incremental_upsert = PostgresOperator(
            task_id='incremental_upsert_dim_payment_justify',
            postgres_conn_id='postgres_default',
            sql='sql/load_dim_payment_justify.sql',
        )
