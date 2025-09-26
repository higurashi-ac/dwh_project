import logging
from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from airflow.models import Variable
from datetime import datetime
import pandas as pd
from sqlalchemy import create_engine

# Table metadata
TABLES = [
    {"name": "hr_employee", "pk": "employee_id", "inc_col": "write_date"},
    {"name": "res_partner", "pk": "partner_id", "inc_col": "write_date"},
    {"name": "planning_slot", "pk": "planning_slot_id", "inc_col": "write_date"},
    {"name": "sale_order", "pk": "sale_order_id", "inc_col": "write_date"},
    {"name": "sale_order_line", "pk": "sale_order_line_id", "inc_col": "write_date"},
    {"name": "purchase_order", "pk": "purchase_order_id", "inc_col": "write_date"},
    {"name": "purchase_order_line", "pk": "purchase_order_line_id", "inc_col": "write_date"},
    {"name": "account_move", "pk": "account_move_id", "inc_col": "write_date"},
    {"name": "account_journal", "pk": "account_journal_id", "inc_col": "write_date"},
    {"name": "payment_justify", "pk": "payment_justify_id", "inc_col": "write_date"},
]

# --- Helper function to create staging tables dynamically ---
def ensure_staging_tables(source_conn_id, target_conn_id, tables):
    source_hook = PostgresHook(postgres_conn_id=source_conn_id)
    target_hook = PostgresHook(postgres_conn_id=target_conn_id)

    # Ensure staging schema exists
    target_hook.run("CREATE SCHEMA IF NOT EXISTS stg;")
    logging.info("✅ Ensured stg schema exists")
    target_hook.run("CREATE SCHEMA IF NOT EXISTS dwh;")
    logging.info("✅ Ensured dwh schema exists")

    for table in tables:
        table_name = table['name']

        cols_info = source_hook.get_records(f"""
        SELECT a.attname,
               pg_catalog.format_type(a.atttypid, a.atttypmod) AS data_type
        FROM pg_attribute a
        JOIN pg_class c ON c.oid = a.attrelid
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = '{table_name}'
          AND n.nspname = 'public'
          AND a.attnum > 0
          AND NOT a.attisdropped;
        """)

        if not cols_info:
            logging.warning(f"Source table {table_name} has no columns, skipping")
            continue

        columns_sql = ", ".join([f'"{col}" {dtype}' for col, dtype in cols_info])
        create_sql = f"CREATE TABLE IF NOT EXISTS stg.{table_name} ({columns_sql});"
        target_hook.run(create_sql)
        logging.info(f"✅ Ensured stg.{table_name} exists with columns: {columns_sql}")

# from chat to resolve error of  :sqlalchemy.exc.ProgrammingError: (psycopg2.ProgrammingError) invalid dsn: invalid connection option "__extra__"
# --- Helper to get clean SQLAlchemy engine ---
def get_clean_engine(conn_id):
    hook = PostgresHook(postgres_conn_id=conn_id)
    uri = hook.get_uri()
    # Remove __extra__ if present
    uri_clean = uri.split("?")[0]
    return create_engine(uri_clean)


# --- Main function to load data ---
def load_stg(**context):
    source_system = Variable.get("stg_source_system", default_var="odoo")
    conn_map = {"odoo": "postgres_odoo", "public": "postgres_public"}
    source_conn_id = conn_map.get(source_system, "postgres_odoo")
    target_conn_id = "postgres_public"

    logging.info(f"Source connection: {source_conn_id}")
    logging.info(f"Target connection: {target_conn_id}")

    source_hook = PostgresHook(postgres_conn_id=source_conn_id)
    target_hook = PostgresHook(postgres_conn_id=target_conn_id)

    # Test connections
    source_hook.get_first("SELECT 1;")
    logging.info(f"✅ Source {source_conn_id} connected")
    target_hook.get_first("SELECT 1;")
    logging.info(f"✅ Target {target_conn_id} connected")

    # SQLAlchemy engine for Pandas (clean URI)
    target_engine = get_clean_engine(target_conn_id)

    for table in TABLES:
        table_name = table['name']
        inc_col = table.get('inc_col')

        # --- Determine last load timestamp in staging ---
        last_ts = None
        if inc_col:
            last_ts_result = target_hook.get_first(f"SELECT MAX({inc_col}) FROM stg.{table_name}")
            if last_ts_result:
                last_ts = last_ts_result[0]

        # --- Read from source (incremental or full) ---
        if last_ts:
            query = f"SELECT * FROM public.{table_name} WHERE {inc_col} > %s"
            df = pd.read_sql(query, source_hook.get_conn(), params=[last_ts])
            logging.info(f"Incremental load for {table_name}: {len(df)} new rows")
        else:
            query = f"SELECT * FROM public.{table_name}"
            df = pd.read_sql(query, source_hook.get_conn())
            logging.info(f"Full load for {table_name}: {len(df)} rows")

        if df.empty:
            logging.info(f"No new data to load for {table_name}")
            continue

        # --- Insert data using Pandas ---
        df.to_sql(table_name, target_engine, schema="stg", if_exists="append", index=False)

        # --- Report rows in staging ---
        rows = target_hook.get_first(f"SELECT COUNT(*) FROM stg.{table_name}")[0]
        logging.info(f"{table_name}: {rows} rows now in stg")

# --- DAG definition ---
with DAG(
    dag_id="stg_loader_dag",
    schedule_interval="*/10 * * * *",
    start_date=datetime(2025, 9, 16),
    catchup=False,
    max_active_runs=1,
    tags=["stg", "dynamic", "pandas"],
) as dag:

    # Step 1: Ensure staging tables exist
    ensure_staging = PythonOperator(
        task_id="ensure_staging_tables",
        python_callable=lambda **context: ensure_staging_tables(
            source_conn_id="postgres_odoo",
            target_conn_id="postgres_public",
            tables=TABLES
        ),
        provide_context=True,
    )

    # Step 2: Load data
    load_staging = PythonOperator(
        task_id="load_staging_tables",
        python_callable=load_stg,
        provide_context=True,
    )

    ensure_staging >> load_staging
