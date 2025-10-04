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

load_mode = Variable.get("load_mode_dim_employee", default_var="INCREMENTAL")

def build_dim_employee_sql():
    """
    Build SQL dynamically for dim_employee:
    - CREATE TABLE with fixed + dynamic columns
    - UPSERT from staging
    - Auditing fields added
    """
    pg_hook = PostgresHook(postgres_conn_id="postgres_public")

    # Get staging columns
    cols_info = pg_hook.get_records("""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'stg'
          AND table_name = 'hr_employee'
        ORDER BY ordinal_position;
    """)

    if not cols_info:
        raise ValueError("No columns found in stg.hr_employee")

    # Fixed part of dimension
    fixed_columns = [
        '"employee_sk" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY',
        '"employee_id" INT UNIQUE'
    ]

    # Dynamic part, insert/upsert lists
    dynamic_columns = []
    insert_cols = ['employee_id']
    insert_select = ['id AS employee_id']
    update_set = []

    for col_name, data_type in cols_info:
        if col_name == "id":
            continue  # already mapped to employee_id

        # Normalize Postgres types to dimension-friendly types
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
        insert_select.append(col_name)
        update_set.append(f'{col_name} = EXCLUDED.{col_name}')

    # Add auditing columns
    audit_columns = [
        '"etl_loaded_at" TIMESTAMP DEFAULT now()',
        '"etl_batch_id" VARCHAR'
    ]
    dynamic_columns += audit_columns
    insert_cols += ['etl_loaded_at', 'etl_batch_id']
    insert_select += ['now()', 'gen_random_uuid()']  # example batch id
    update_set += ['etl_loaded_at = EXCLUDED.etl_loaded_at', 'etl_batch_id = EXCLUDED.etl_batch_id']

    # Build CREATE TABLE
    create_sql = f"""
    CREATE SCHEMA IF NOT EXISTS dwh;

    CREATE TABLE IF NOT EXISTS dwh.dim_employee (
        {', '.join(fixed_columns + dynamic_columns)}
    );
    """

    # Build UPSERT statement
    upsert_sql = f"""
    INSERT INTO dwh.dim_employee (
        {', '.join(insert_cols)}
    )
    SELECT
        {', '.join(insert_select)}
    FROM stg.hr_employee s
    ON CONFLICT (employee_id) DO UPDATE
    SET {', '.join(update_set)};
    """

    full_sql = create_sql + "\n" + upsert_sql
    logging.info(f"Generated SQL for dim_employee:\n{full_sql}")
    return full_sql


with DAG(
    'dim_employee',
    default_args=default_args,
    description='ETL DAG for dim_employee (auto schema + upsert)',
    schedule_interval=None,
    start_date=datetime(2025, 9, 16),
    catchup=False,
    tags=['dwh', 'dimension'],
) as dag:

    # Optionally truncate first if FULL load
    if load_mode.upper() == "FULL":
        truncate_task = PostgresOperator(
            task_id='truncate_dim_employee',
            postgres_conn_id='postgres_public',
            sql='TRUNCATE TABLE dwh.dim_employee;'
        )
        load_task = PostgresOperator(
            task_id='load_dim_employee_full',
            postgres_conn_id='postgres_public',
            sql=build_dim_employee_sql()
        )
        truncate_task >> load_task
    else:
        load_task = PostgresOperator(
            task_id='load_dim_employee_incremental',
            postgres_conn_id='postgres_public',
            sql=build_dim_employee_sql()
        )