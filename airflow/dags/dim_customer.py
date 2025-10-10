from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from audit_utils import log_etl_status
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

def run_and_audit(table_name, sql_builder, **context):
    task_id = context["task"].task_id
    dag_id = context["dag"].dag_id
    started_at = datetime.now()
    pg_hook = PostgresHook(postgres_conn_id="postgres_public")

    try:
        sql = sql_builder(table_name)
        pg_hook.run(sql)
        rows = pg_hook.get_first(f"SELECT COUNT(*) FROM dwh.dim_{table_name};")
        rows = rows[0] if rows else 0

        log_etl_status(
            dag_id=dag_id,
            task_id=task_id,
            table_name=f"dwh.dim_{table_name}",
            status="SUCCESS",
            rows_affected=rows,
            started_at=started_at
        )
    except Exception as e:
        log_etl_status(
            dag_id=dag_id,
            task_id=task_id,
            table_name=f"dwh.dim_{table_name}",
            status="FAILED",
            error_message=str(e),
            started_at=started_at
        )
        raise

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
    insert_cols = ['id']
    insert_select = ['id']
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

    upsert_sql = f"""
    INSERT INTO dwh.dim_{table_name} (
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
    SET {', '.join(update_set)}
   
    ;
    """
    full_sql = create_sql + "\n" + upsert_sql
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
            "table_name": TABLE_NAME,
            "sql_builder": build_dim_sql
        }
    )
