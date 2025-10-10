import os
import psycopg2
from dotenv import load_dotenv

# Load the .env file one level up
dotenv_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".env"))
load_dotenv(dotenv_path)

# Configuration
DAGS_DIR = "./airflow/dags"
VIEWS_DIR = "./views"
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")
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

        # Prepare column lines
        column_lines = []
        for i, col in enumerate(columns):
            col_name = col[0]
            if i < 1:  # first two columns normal
                column_lines.append(f"{col_name}")
            else:      # remaining columns commented
                column_lines.append(f"--,{col_name}")

        if column_lines:
            column_lines[-1] = column_lines[-1].rstrip(",")  # Remove trailing comma

        # Generate SQL view content
        view_sql = f"""CREATE OR REPLACE VIEW dwh.{view_name} AS
SELECT
{os.linesep.join(column_lines).rstrip()}
FROM dwh.{table_name};
"""

        # Strip all blank lines
        view_sql = "\n".join([line for line in view_sql.splitlines() if line.strip()])

        # Write to file
        view_file_path = os.path.join(VIEWS_DIR, f"{view_name}.sql")
        with open(view_file_path, "w") as f:
            f.write(view_sql)

        print(f"Created view file: {view_file_path}")
        try:
            cur.execute(view_sql)
            conn.commit()
            print(f"Executed view creation: {view_name}")
        except Exception as e:
            conn.rollback()
            print(f"Failed to execute {view_name}: {e}")

cur.close()
conn.close()

# python ./utils/create_views_auto_dwh.py : create and run all views and facts 