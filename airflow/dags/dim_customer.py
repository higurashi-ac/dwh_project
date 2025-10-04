from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.models import Variable
import logging

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

load_mode = Variable.get("load_mode_dim_customer", default_var="INCREMENTAL")

def build_dim_customer_sql():
    """
    Build SQL dynamically for dim_customer:
    - CREATE TABLE if not exists
    - UPSERT from dim_partner joining dim_sales_order
    - Auditing fields added
    """
    pg_hook = PostgresHook(postgres_conn_id="postgres_public")

    # Get columns from res_partner
    cols_info = pg_hook.get_records("""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'stg'
          AND table_name = 'res_partner'
        ORDER BY ordinal_position;
    """)

    if not cols_info:
        raise ValueError("No columns found in stg.res_partner")

    fixed_columns = [
        '"customer_sk" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY',
        '"id" INT UNIQUE'
    ]

    dynamic_columns = []
    insert_cols = ['id']
    insert_select = ['p.id']
    update_set = []

    for col_name, data_type in cols_info:
        if col_name in ("id"):
            continue

        if data_type == "character varying":
            dtype = "TEXT"
        elif data_type == "text":
            dtype = "TEXT"
        elif data_type == "timestamp without time zone":
            dtype = "TIMESTAMP"
        elif data_type.startswith("numeric"):
            dtype = "NUMERIC"
        elif data_type == "boolean":
            dtype = "BOOLEAN"
        elif data_type == "date":
            dtype = "DATE"
        else:
            dtype = data_type.upper()

        dynamic_columns.append(f'"{col_name}" {dtype}')
        insert_cols.append(col_name)
        insert_select.append(f"p.{col_name}")
        update_set.append(f"{col_name} = EXCLUDED.{col_name}")

    audit_columns = [
        '"etl_loaded_at" TIMESTAMP DEFAULT now()',
        '"etl_batch_id" VARCHAR'
    ]
    dynamic_columns += audit_columns
    insert_cols += ['etl_loaded_at', 'etl_batch_id']
    insert_select += ['now() AS etl_loaded_at', 'gen_random_uuid() AS etl_batch_id']
    update_set += ['etl_loaded_at = EXCLUDED.etl_loaded_at', 'etl_batch_id = EXCLUDED.etl_batch_id']

    create_sql = f"""
    CREATE SCHEMA IF NOT EXISTS dwh;

    CREATE TABLE IF NOT EXISTS dwh.dim_customer (
        {', '.join(fixed_columns + dynamic_columns)}
    );
    """

    upsert_sql = f"""
    INSERT INTO dwh.dim_customer (
        {', '.join(insert_cols)}
    )
    WITH base AS (
        SELECT DISTINCT {', '.join(insert_select)}
        FROM dwh.dim_partner p
        WHERE EXISTS (
            SELECT 1
            FROM dwh.dim_sale_order s
            WHERE s.partner_id = p.id
        )
    )
    SELECT * FROM base
    ON CONFLICT (id) DO UPDATE
    SET {', '.join(update_set)};
    """

    full_sql = create_sql + "\n" + upsert_sql
    logging.info(f"Generated SQL for dim_customer:\n{full_sql}")
    return full_sql


with DAG(
    'dim_customer',
    default_args=default_args,
    description='ETL DAG for dim_customer',
    #schedule_interval='*/10 * * * *',
    schedule_interval=None,  # no schedule, the main dag => main.py (orchestrator) will decide on this file's order
    start_date=datetime(2025, 9, 16),
    catchup=False,
    tags=['dwh', 'dimension'],
) as dag:

    if load_mode.upper() == "FULL":
        truncate_task = PostgresOperator(
            task_id='truncate_dim_customer',
            postgres_conn_id='postgres_public',
            sql='TRUNCATE TABLE dwh.dim_customer;'
        )
        load_task = PostgresOperator(
            task_id='load_dim_customer_full',
            postgres_conn_id='postgres_public',
            sql=build_dim_customer_sql()
        )
        truncate_task >> load_task
    else:
        load_task = PostgresOperator(
            task_id='load_dim_customer_incremental',
            postgres_conn_id='postgres_public',
            sql=build_dim_customer_sql()
        )
