from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.python import PythonOperator
import holidays

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def generate_french_holidays():
    pg_hook = PostgresHook(postgres_conn_id="postgres_public")
    conn = pg_hook.get_conn()
    cursor = conn.cursor()
    current_year = datetime.now().year
    fr_holidays = holidays.France(years=range(current_year - 5, current_year + 6))
    for date, name in fr_holidays.items():
        cursor.execute(
            """
            INSERT INTO dwh.fr_holidays (holiday_date, holiday_name)
            VALUES (%s, %s)
            ON CONFLICT (holiday_date) DO UPDATE
            SET holiday_name = EXCLUDED.holiday_name;
            """,
            (date, name)
        )
    conn.commit()
    cursor.close()
    conn.close()

sql_dim_date = """
CREATE SCHEMA IF NOT EXISTS dwh;

CREATE TABLE IF NOT EXISTS dwh.dim_date AS
WITH dates AS (
    SELECT d::date AS full_date
    FROM generate_series('2010-01-01'::date, '2050-12-31'::date, interval '1 day') d
),
holidays AS (
    SELECT holiday_date, holiday_name
    FROM dwh.fr_holidays
)
SELECT
    d.full_date,
    EXTRACT(year FROM d.full_date)::int AS year,
    EXTRACT(month FROM d.full_date)::int AS month,
    EXTRACT(day FROM d.full_date)::int AS day,
    TO_CHAR(d.full_date, 'Day') AS weekday_name,
    EXTRACT(isodow FROM d.full_date)::int AS weekday_iso,
    (EXTRACT(isodow FROM d.full_date) IN (6,7)) AS is_weekend,
    CASE WHEN h.holiday_date IS NOT NULL THEN TRUE ELSE FALSE END AS is_holiday,
    h.holiday_name
FROM dates d
LEFT JOIN holidays h
    ON d.full_date = h.holiday_date;
"""

with DAG(
    'dim_date',
    default_args=default_args,
    description='Generate dim_date with French holiday information',
    schedule_interval='@yearly',
    start_date=datetime(2025, 1, 1),
    catchup=False,
    tags=['dwh', 'dimension'],
) as dag:

    create_fr_holidays = PostgresOperator(
        task_id='create_fr_holidays',
        postgres_conn_id='postgres_public',
        sql="""
        CREATE TABLE IF NOT EXISTS dwh.fr_holidays (
            holiday_date DATE PRIMARY KEY,
            holiday_name TEXT
        );
        """
    )

    generate_holidays_task = PythonOperator(
        task_id="generate_french_holidays",
        python_callable=generate_french_holidays,
    )

    create_dim_date_task = PostgresOperator(
        task_id='create_dim_date',
        postgres_conn_id='postgres_public',
        sql=sql_dim_date
    )

    create_fr_holidays >> generate_holidays_task >> create_dim_date_task
