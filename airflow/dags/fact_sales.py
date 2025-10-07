from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Your fact_sales SQL
sql_fact_sales = """
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.fact_sales (
      order_date DATE
    , order_id INT
    , order_line_id INT
    , customer_id INT
    , price_unit NUMERIC
    , product_uom_qty NUMERIC
    , discount NUMERIC
    , price_subtotal NUMERIC
    , price_tax NUMERIC
    , price_total NUMERIC
    , price_reduce NUMERIC
);

-- Optional: clear before reloading (uncomment if you want a full refresh)
-- TRUNCATE TABLE dwh.fact_sales;

INSERT INTO dwh.fact_sales (
      order_date
    , order_id
    , order_line_id
    , customer_id
    , price_unit
    , product_uom_qty
    , discount
    , price_subtotal
    , price_tax
    , price_total
    , price_reduce
)
WITH base AS (
    SELECT
          s.date_order   AS order_date
        , s.id           AS order_id
        , sl.id          AS order_line_id
        , c.id           AS customer_id
        --, p.product_id   AS product_id  -- future join
        , sl.price_unit
        , sl.product_uom_qty
        , sl.discount
        , sl.price_subtotal
        , sl.price_tax
        , sl.price_total
        , sl.price_reduce

    FROM dwh.dim_sale_order_line sl
    JOIN dwh.dim_sale_order s ON sl.order_id = s.id
    --JOIN dwh.dim_date d ON s.date_order::date = d.full_date -- to be dealt with in reporting layer (Metabase)
    JOIN dwh.dim_customer c ON s.partner_id = c.id
    --JOIN dwh.dim_product p ON sl.product_id = p.id  -- to be added later
)
SELECT *
FROM base
ORDER BY order_date DESC, order_id, order_line_id;
"""

with DAG(
    'fact_sales',
    default_args=default_args,
    description='ETL DAG for fact_sales',
    schedule_interval=None,  # set @daily or @hourly later if needed
    start_date=datetime(2025, 10, 5),
    catchup=False,
    tags=['dwh', 'fact'],
) as dag:

    create_and_load_fact_sales = PostgresOperator(
        task_id='create_and_load_fact_sales',
        postgres_conn_id='postgres_public',
        sql=sql_fact_sales,
    )

    create_and_load_fact_sales
