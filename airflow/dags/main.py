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
    max_active_runs=4,
    description='Master orchestrator DAG for staging, dimensions, and facts',
    schedule_interval='*/15 7-18 * * 1-5',  # Every 15 minutes from 7 AM to 6:45 PM, Monday to Friday
    start_date=datetime(2025, 9, 16),
    catchup=False,
    tags=['orchestrator', 'dwh'],
) as dag:

    # Detached dimension
    #dim_date = TriggerDagRunOperator(
    #    task_id="run_dim_date",
    #    trigger_dag_id="dim_date",
    #    wait_for_completion=True
    #)
    
    # Staging loader
    stg_loader = TriggerDagRunOperator(
        task_id="run_stg_loader",
        trigger_dag_id="stg_loader",
        wait_for_completion=True
    )

    # Dimension DAG names
    dim_dags = [
        #"dim_date"
         "dim_hr_employee"
        ,"dim_res_partner"
        ,"dim_planning_slot"
        ,"dim_sale_order"
        ,"dim_sale_order_line"
        ,"dim_purchase_order"
        ,"dim_purchase_order_line"
        ,"dim_account_move"
        ,"dim_account_journal"
        ,"dim_payment_justify"
        ,"dim_product_product"
        ,"dim_product_template"
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

    # Unpacking dimension tasks for easier access
    dim_hr_employee         = dim_tasks["dim_hr_employee"]
    dim_res_partner         = dim_tasks["dim_res_partner"]
    dim_planning_slot       = dim_tasks["dim_planning_slot"]
    dim_sale_order          = dim_tasks["dim_sale_order"]
    dim_sale_order_line     = dim_tasks["dim_sale_order_line"]
    dim_purchase_order      = dim_tasks["dim_purchase_order"]
    dim_purchase_order_line = dim_tasks["dim_purchase_order_line"]
    dim_account_move        = dim_tasks["dim_account_move"]
    dim_account_journal     = dim_tasks["dim_account_journal"]
    dim_payment_justify     = dim_tasks["dim_payment_justify"]
    dim_product_product     = dim_tasks["dim_product_product"]
    dim_product_template     = dim_tasks["dim_product_template"]

    
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
    fact_sales = TriggerDagRunOperator(
        task_id="run_fact_sales",
        trigger_dag_id="fact_sales",
        wait_for_completion=True
    )

    fact_purchases = TriggerDagRunOperator(
        task_id="run_fact_purchases",
        trigger_dag_id="fact_purchases",
        wait_for_completion=True
    )


    # Orchestration order
    #dim_date
    stg_loader >> list(dim_tasks.values())
    
    # Customer dependencies
    dim_res_partner >> dim_customer
    dim_sale_order >> dim_customer

    # Supplier dependencies
    dim_res_partner >> dim_supplier
    dim_purchase_order >> dim_supplier

    # Facts dependencies
    [dim_customer, dim_sale_order, dim_sale_order_line , dim_product_product,dim_product_template] >> fact_sales
    [dim_supplier, dim_purchase_order, dim_purchase_order_line ,dim_product_product,dim_product_template] >> fact_purchases
