from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from run_and_audit import run_and_audit
import logging
import os


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=2),
}

def build_dim_sql(table_name):
    pg_hook = PostgresHook(postgres_conn_id="postgres_public")

    cols_info = pg_hook.get_records(f"""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'stg'
          AND table_name = '{table_name}'
        ORDER BY ordinal_position;
    """)

    if not cols_info:
        raise ValueError(f"No columns found in stg.{table_name}")

    fixed_columns = [
        f'"{table_name}_sk" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY',
        '"id" INT UNIQUE'
    ]

    dynamic_columns = []
    insert_cols = ['"id"']
    insert_select = ['"id"']
    update_set = []

    for col_name, data_type in cols_info:
        if col_name == "id":
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

        #sensitive case "majus"
        col_name = f'"{col_name}"'
        dynamic_columns.append(f'{col_name} {dtype}')
        insert_cols.append(col_name)
        insert_select.append(col_name)
        update_set.append(f'{col_name} = EXCLUDED.{col_name}')

    audit_columns = [
        '"etl_loaded_at" TIMESTAMP DEFAULT now()',
        '"etl_batch_id" VARCHAR'
    ]
    dynamic_columns += audit_columns
    insert_cols += ['etl_loaded_at', 'etl_batch_id']
    insert_select += ['now() AS "etl_loaded_at"', 'gen_random_uuid() AS "etl_batch_id"']
    update_set += ['"etl_loaded_at" = EXCLUDED."etl_loaded_at"', '"etl_batch_id" = EXCLUDED."etl_batch_id"']

    create_sql = f"""
    CREATE TABLE IF NOT EXISTS dwh.dim_{table_name} (
        {', '.join(fixed_columns + dynamic_columns)}
    );
    """

    delete_sql = f"""
    delete from dwh.dim_{table_name} d
    where order_id in (select distinct order_id
        from stg.sale_order_line
        where write_date >= NOW() - INTERVAL '30 minutes' 
        );
    """

    upsert_sql = f"""
    INSERT INTO dwh.dim_{table_name} (
        {', '.join(insert_cols)}
    )
    with base as 
    (SELECT
        {', '.join(insert_select)}
        ,row_number() over(partition by id order by write_date desc) as rn 
        ,CASE WHEN write_date = max(write_date) OVER(PARTITION BY order_id) THEN 1 ELSE 0 end as maxdate
    FROM stg.{table_name} s)
    ,final as (select {', '.join(insert_cols)} from base where rn =1 and maxdate = 1) 
        
    select * from final 
    ON CONFLICT (id) DO UPDATE
    SET {', '.join(update_set)}
   
    ;
    """
    full_sql = create_sql + "\n" + delete_sql + "\n" + upsert_sql
    logger = logging.getLogger(__name__)
    return full_sql


TABLE_NAME = os.path.splitext(os.path.basename(__file__))[0].replace("dim_", "")
if not TABLE_NAME:
    raise ValueError("Invalid DAG filename format. Expected dim_<table>.py")

with DAG(
    dag_id=f'dim_{TABLE_NAME}',
    default_args=default_args,
    description=f'ETL DAG for dim_{TABLE_NAME} (auto schema + upsert)',
    schedule_interval=None,
    start_date=datetime(2025, 9, 16),
    catchup=False,
    max_active_runs=1,
    tags=['dwh', 'dimension'],
) as dag:

    load_task = PythonOperator(
        task_id=f"load_dim_{TABLE_NAME}",
        python_callable=run_and_audit,
        op_kwargs={
            'table_type': 'dim',
            'table_name': f'{TABLE_NAME}',
            'sql_builder': build_dim_sql
        }
    )
    load_task