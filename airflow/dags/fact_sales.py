from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from run_and_audit import run_and_audit

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

sql_fact_sales = """
CREATE TABLE IF NOT EXISTS dwh.fact_sales (
    order_date DATE,
    order_id INT,
    order_line_id INT,
    order_seq VARCHAR,
    customer_id INT,
    price_unit NUMERIC,
    product_uom_qty NUMERIC,
    discount NUMERIC,
    price_subtotal NUMERIC,
    price_tax NUMERIC,
    price_total NUMERIC,
    price_reduce NUMERIC,
    etl_loaded_at TIMESTAMP DEFAULT now(),
    etl_batch_id VARCHAR
);
WITH base AS (
    SELECT
        s.date_order        AS order_date,
        s.id                AS order_id,
        sl.id               AS order_line_id,
        concat(
            s.id, '-',
            row_number() OVER (PARTITION BY s.id ORDER BY sl.id, sl.create_date)
        )                   AS order_seq,
        c.id                AS customer_id,
        sl.price_unit,
        sl.product_uom_qty,
        sl.discount,
        sl.price_subtotal,
        sl.price_tax,
        sl.price_total,
        sl.price_reduce,
        now()               AS etl_loaded_at,
        gen_random_uuid()   AS etl_batch_id
    
    FROM dwh.dim_sale_order_line sl
    JOIN dwh.dim_sale_order s ON sl.order_id = s.id
    JOIN dwh.dim_customer c   ON s.partner_id = c.id
)

MERGE INTO dwh.fact_sales AS target
USING base AS source
ON target.order_id = source.order_id
   AND target.order_line_id = source.order_line_id
WHEN MATCHED THEN
    UPDATE SET
        order_date     = source.order_date,
        order_seq      = source.order_seq,
        customer_id    = source.customer_id,
        price_unit     = source.price_unit,
        product_uom_qty= source.product_uom_qty,
        discount       = source.discount,
        price_subtotal = source.price_subtotal,
        price_tax      = source.price_tax,
        price_total    = source.price_total,
        price_reduce   = source.price_reduce,
        etl_loaded_at  = source.etl_loaded_at,
        etl_batch_id   = source.etl_batch_id
WHEN NOT MATCHED THEN
    INSERT (
        order_date,
        order_id,
        order_line_id,
        order_seq,
        customer_id,
        price_unit,
        product_uom_qty,
        discount,
        price_subtotal,
        price_tax,
        price_total,
        price_reduce,
        etl_loaded_at,
        etl_batch_id
    )
    VALUES (
        source.order_date,
        source.order_id,
        source.order_line_id,
        source.order_seq,
        source.customer_id,
        source.price_unit,
        source.product_uom_qty,
        source.discount,
        source.price_subtotal,
        source.price_tax,
        source.price_total,
        source.price_reduce,
        source.etl_loaded_at,
        source.etl_batch_id
    );
"""

def build_fact_sales_sql(table_name):
    return sql_fact_sales


with DAG(
    dag_id='fact_sales',
    default_args=default_args,
    description='ETL DAG for fact_sales with audit logging',
    schedule_interval=None,
    start_date=datetime(2025, 10, 5),
    catchup=False,
    tags=['dwh', 'fact'],
) as dag:

    load_fact_sales = PythonOperator(
        task_id='load_fact_sales',
        python_callable=run_and_audit,
        op_kwargs={
            'table_type': 'fact',
            'table_name': 'sales',
            'sql_builder': build_fact_sales_sql
        }
    )

    load_fact_sales
