
from airflow import DAG
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
from airflow.models import Variable
from datetime import datetime

# Table metadata: table name, primary key, optional incremental column
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

def load_stg(**context):
    # Read the source switch variable: 'public' or 'odoo'
    source_system = Variable.get("stg_source_system", default_var="public")
    source_conn_id = "postgres_public" if source_system == "public" else "postgres_odoo"
    target_conn_id = "postgres_public"  # staging is always in dev_dwh.public for now
    
    source_hook = PostgresHook(postgres_conn_id=source_conn_id)
    target_hook = PostgresHook(postgres_conn_id=target_conn_id)
    
    for table in TABLES:
        table_name = table['name']
        pk = table['pk']
        inc_col = table.get('inc_col')
        
        # Determine last load timestamp from staging
        last_ts = target_hook.get_first(f"SELECT MAX({inc_col}) FROM stg.{table_name}") if inc_col else None
        
        if last_ts and last_ts[0]:
            insert_sql = f"""
            INSERT INTO stg.{table_name} 
            SELECT * FROM public.{table_name} 
            WHERE {inc_col} > '{last_ts[0]}'
            """
        else:
            insert_sql = f"INSERT INTO stg.{table_name} SELECT * FROM public.{table_name}"
        
        target_hook.run(insert_sql)
        
        # Get number of rows inserted
        count_sql = f"SELECT COUNT(*) FROM stg.{table_name}" 
        rows = target_hook.get_first(count_sql)[0]
        print(f"{table_name}: {rows} rows now in staging")

with DAG(
    dag_id="stg_loader_dag",
    schedule_interval="*/10 * * * *",  # every 10 minutes
    start_date=datetime(2025, 9, 16),
    catchup=False,
    max_active_runs=1,
    tags=["stg", "dynamic"],
) as dag:

    load_staging = PythonOperator(
        task_id="load_staging_tables",
        python_callable=load_stg,
        provide_context=True,
    )
