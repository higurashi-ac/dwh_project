import logging
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime

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
