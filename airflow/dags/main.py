from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'main_dag',
    default_args=default_args,
    description='Master orchestrator DAG for staging, dimensions, and facts',
    schedule_interval='*/30 * * * *',
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

    # Dimension DAG names
    dim_dags = [
        "dim_date"
        ,"dim_employee"
        ,"dim_partner"
        ,"dim_planning_slot"
        ,"dim_sale_order"
        ,"dim_sale_order_line"
        ,"dim_purchase_order"
        ,"dim_purchase_order_line"
        ,"dim_account_move"
        ,"dim_account_journal"
        ,"dim_payment_justify"
    ]

    # Create Trigger tasks dynamically for dimension DAGs
    dim_tasks = {
        dag_name: TriggerDagRunOperator(
            task_id=f"run_{dag_name}",
            trigger_dag_id=dag_name,
            wait_for_completion=True
        )
        for dag_name in dim_dags
    }

    # Dependent dimension DAGs
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

    # Fact tables
    #fact_sales = TriggerDagRunOperator(
    #    task_id="run_fact_sales",
    #    trigger_dag_id="fact_sales",
    #    wait_for_completion=True
    #)

    #fact_purchases = TriggerDagRunOperator(
    #    task_id="run_fact_purchases",
    #    trigger_dag_id="fact_purchases",
    #    wait_for_completion=True
    #)

    # Orchestration order
    stg_loader >> list(dim_tasks.values())

    # Customer dependencies
    dim_tasks["dim_partner"] >> dim_customer
    dim_tasks["dim_sale_order"] >> dim_customer

    # Supplier dependencies
    dim_tasks["dim_partner"] >> dim_supplier
    dim_tasks["dim_purchase_order"] >> dim_supplier

    # Facts dependencies
    #[dim_customer, dim_sale_order, dim_sale_order_line] >> fact_sales
    #[dim_supplier, dim_purchase_order, dim_purchase_order_line] >> fact_purchases
