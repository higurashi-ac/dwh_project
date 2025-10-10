from datetime import datetime
from airflow.providers.postgres.hooks.postgres import PostgresHook
import logging


def log_etl_status(
    dag_id,
    task_id,
    table_name,
    status,
    rows_affected=None,
    error_message=None,
    started_at=None
):
    """Insert audit info into ctrl.etl_audit"""
    finished_at = datetime.now()
    duration = (finished_at - started_at).total_seconds() if started_at else None

    pg_hook = PostgresHook(postgres_conn_id="postgres_public")
    sql = """
        INSERT INTO ctrl.etl_audit (
            dag_id, task_id, table_name, status,
            rows_affected, started_at, finished_at, duration_seconds, error_message
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
    """

    pg_hook.run(sql, parameters=[
        dag_id, task_id, table_name, status,
        rows_affected, started_at, finished_at, duration, error_message
    ])
    logging.info(f"Audit logged for {dag_id}.{task_id} with status {status}")


def run_and_audit(table_type, table_name, sql_builder, **context):
    """
    Execute an ETL SQL for either a dimension or fact table,
    log audit information, and handle errors gracefully.
    """
    task_id = context["task"].task_id
    dag_id = context["dag"].dag_id
    started_at = datetime.now()
    pg_hook = PostgresHook(postgres_conn_id="postgres_public")

    # Normalize table type
    if table_type not in ("dim", "fact"):
        raise ValueError("table_type must be 'dim' or 'fact'")

    full_table_name = f"dwh.{table_type}_{table_name}".lower()
    logging.info(f"Running ETL for {full_table_name}")

    try:
        # Check if the table exists
        table_exists = pg_hook.get_first(f"""
            SELECT EXISTS (
                SELECT FROM information_schema.tables
                WHERE table_schema = 'dwh'
                AND table_name = '{table_type}_{table_name}'
            );
        """)[0]

        if table_exists:
            before_count = pg_hook.get_first(f"SELECT COUNT(*) FROM {full_table_name};")[0]
        else:
            before_count = 0

        # Build and execute the SQL
        sql = sql_builder(table_name)
        pg_hook.run(sql)

        after_count = pg_hook.get_first(f"SELECT COUNT(*) FROM {full_table_name};")[0]
        impacted_count = after_count - before_count

        log_etl_status(
            dag_id=dag_id,
            task_id=task_id,
            table_name=full_table_name,
            status="SUCCESS",
            rows_affected=impacted_count,
            started_at=started_at
        )
    except Exception as e:
        log_etl_status(
            dag_id=dag_id,
            task_id=task_id,
            table_name=full_table_name,
            status="FAILED",
            error_message=str(e),
            started_at=started_at
        )
        raise
