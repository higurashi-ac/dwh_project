import os
import psycopg2

# Configuration
DAGS_DIR = "dwh_project/airflow/dags"
VIEWS_DIR = "dwh_project/views"
DB_NAME = "your_database"
DB_USER = "your_user"
DB_PASSWORD = "your_password"
DB_HOST = "localhost"
DB_PORT = "5432"

os.makedirs(VIEWS_DIR, exist_ok=True)

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cur = conn.cursor()

# Loop over DAG files
for dag_file in os.listdir(DAGS_DIR):
    if dag_file.endswith(".py") and ("dim" in dag_file or "fact" in dag_file):
        table_name = dag_file.replace(".py", "")
        view_name = f"vw_{table_name}"

        # Get column names for the table
        cur.execute("""
            SELECT column_name
            FROM information_schema.columns
            WHERE table_schema = 'dwh'
              AND table_name = %s
            ORDER BY ordinal_position;
        """, (table_name,))
        columns = cur.fetchall()

        # Prepare commented column list
        column_lines = [f"--{col[0]}," for col in columns]
        if column_lines:
            column_lines[-1] = column_lines[-1].rstrip(",")  # Remove comma for last column

        # Generate SQL view content
        view_sql = f"""CREATE OR REPLACE VIEW dwh.{view_name} AS
SELECT
{os.linesep.join(column_lines)}
FROM dwh.{table_name};
"""

        # Write to file
        view_file_path = os.path.join(VIEWS_DIR, f"{view_name}.sql")
        with open(view_file_path, "w") as f:
            f.write(view_sql)

        print(f"Created view file: {view_file_path}")

cur.close()
conn.close()
