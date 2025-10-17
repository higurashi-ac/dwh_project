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

sql_fact_purchases = """
CREATE TABLE IF NOT EXISTS dwh.fact_purchases (
    order_date DATE,
    order_id INT,
    order_line_id INT,
    order_seq VARCHAR,
    supplier_id INT,
    price_unit NUMERIC,
    product_uom_qty NUMERIC,
    discount NUMERIC,
    price_subtotal NUMERIC,
    price_tax NUMERIC,
    price_total NUMERIC,
    etl_loaded_at TIMESTAMP DEFAULT now(),
    etl_batch_id VARCHAR
);
WITH base AS (
    SELECT
        p.date_order        AS order_date,
        p.id                AS order_id,
        pl.id               AS order_line_id,
        concat(
            p.id, '-',
            row_number() OVER (PARTITION BY p.id ORDER BY pl.id, pl.create_date)
        )                   AS order_seq,
        s.id                AS supplier_id,
        pl.price_unit,
        pl.product_uom_qty,
        pl.discount,
        pl.price_subtotal,
        pl.price_tax,
        pl.price_total,
        now()               AS etl_loaded_at,
        gen_random_uuid()   AS etl_batch_id
    
    FROM dwh.dim_purchase_order_line pl
    JOIN dwh.dim_purchase_order p ON pl.order_id = p.id
    JOIN dwh.dim_supplier s   ON p.partner_id = s.id
)

MERGE INTO dwh.fact_purchases AS target
USING base AS source
ON target.order_id = source.order_id
   AND target.order_line_id = source.order_line_id
WHEN MATCHED THEN
    UPDATE SET
        order_date     = source.order_date,
        order_seq      = source.order_seq,
        supplier_id    = source.supplier_id,
        price_unit     = source.price_unit,
        product_uom_qty= source.product_uom_qty,
        discount       = source.discount,
        price_subtotal = source.price_subtotal,
        price_tax      = source.price_tax,
        price_total    = source.price_total,
        etl_loaded_at  = source.etl_loaded_at,
        etl_batch_id   = source.etl_batch_id
WHEN NOT MATCHED THEN
    INSERT (
        order_date,
        order_id,
        order_line_id,
        order_seq,
        supplier_id,
        price_unit,
        product_uom_qty,
        discount,
        price_subtotal,
        price_tax,
        price_total,
        etl_loaded_at,
        etl_batch_id
    )
    VALUES (
        source.order_date,
        source.order_id,
        source.order_line_id,
        source.order_seq,
        source.supplier_id,
        source.price_unit,
        source.product_uom_qty,
        source.discount,
        source.price_subtotal,
        source.price_tax,
        source.price_total,
        source.etl_loaded_at,
        source.etl_batch_id
    );
"""

def build_fact_purchases_sql(table_name):
    return sql_fact_purchases


with DAG(
    dag_id='fact_purchases',
    default_args=default_args,
    description='ETL DAG for fact_purchases with audit logging',
    schedule_interval=None,
    start_date=datetime(2025, 10, 5),
    catchup=False,
    tags=['dwh', 'fact'],
) as dag:

    load_fact_purchases = PythonOperator(
        task_id='load_fact_purchases',
        python_callable=run_and_audit,
        op_kwargs={
            'table_type': 'fact',
            'table_name': 'purchases',
            'sql_builder': build_fact_purchases_sql
        }
    )

    load_fact_purchases
