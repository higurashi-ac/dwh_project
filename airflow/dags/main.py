import os
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

# Default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

DAG_FOLDER = "/opt/airflow/dags"

with DAG(
    'main_dag',
    default_args=default_args,
    max_active_tasks=2,
    description='Master orchestrator DAG for staging, dimensions, and facts',
    schedule_interval=None, #'*/15 * * * *',
    start_date=datetime(2025, 9, 16),
    catchup=False,
    tags=['orchestrator', 'dwh'],
) as dag:

    # Stage loader
    stg_loader = TriggerDagRunOperator(
        task_id="run_stg_loader",
        trigger_dag_id="stg_loader",
        wait_for_completion=True
    )

    # Dynamically find DAG files in the folder
    all_dag_files = [
        f[:-3] for f in os.listdir(DAG_FOLDER)
        if f.endswith(".py") and f != "main.py" and f != "stg_loader.py"
    ]

    # DAGs that should not be included in the auto-trigger loop
    dependant_dags = [
        "stg_loader",
        "main_dag",
        "dim_customer",
        "dim_supplier",
        "fact_sales",
        # "fact_purchases"  # hedhi later, prbly finance too
    ]

    # Exclude dependant DAGs
    dim_dags = [dag_name for dag_name in all_dag_files if dag_name not in dependant_dags]

    # Create Trigger tasks dynamically
    dim_tasks = {
        dag_name: TriggerDagRunOperator(
            task_id=f"run_{dag_name}",
            trigger_dag_id=dag_name,
            wait_for_completion=True
        )
        for dag_name in dim_dags
    }

    # Dependent DAGs defined manually
    dim_customer = TriggerDagRunOperator(
        task_id="run_dim_customer",
        trigger_dag_id="dim_customer",
        wait_for_completion=True
    )

    dim_supplier = TriggerDagRunOperator(
        task_id="run_dim_supplier",
        trigger_dag_id="dim_supplier",
        wait_for_completion=True
    )

    fact_sales = TriggerDagRunOperator(
        task_id="run_fact_sales",
        trigger_dag_id="fact_sales",
        wait_for_completion=True
    )

    # Orchestration
    stg_loader >> list(dim_tasks.values())

    # Dependencies between DAGs
    if "dim_partner" in dim_tasks and "dim_sale_order" in dim_tasks and "dim_purchase_order" in dim_tasks:
        dim_partner = dim_tasks["dim_partner"]
        dim_sale_order = dim_tasks["dim_sale_order"]
        dim_purchase_order = dim_tasks["dim_purchase_order"]

        # Customer dependencies
        dim_partner >> dim_customer
        dim_sale_order >> dim_customer

        # Supplier dependencies
        dim_partner >> dim_supplier
        dim_purchase_order >> dim_supplier

        # Facts dependencies
        [dim_customer, dim_sale_order, dim_tasks.get("dim_sale_order_line")] >> fact_sales
        #[dim_supplier, dim_purchase_order, dim_purchase_order_line] >> fact_purchases