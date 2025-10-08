import os
import psycopg2
from dotenv import load_dotenv

# Load environment variables
dotenv_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".env"))
load_dotenv(dotenv_path)

# Configuration
VIEWS_DIR = "./views"
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")
DB_HOST = "localhost"
DB_PORT = "5432"

# Ensure the views directory exists
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

print("Dropping all existing views under schema dwh...")

drop_views_sql = """
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT table_name
        FROM information_schema.views
        WHERE table_schema = 'dwh'
    )
    LOOP
        EXECUTE format('DROP VIEW IF EXISTS dwh.%I CASCADE;', r.table_name);
    END LOOP;
END $$;
"""

try:
    cur.execute(drop_views_sql)
    conn.commit()
    print("All views dropped successfully.")
except Exception as e:
    conn.rollback()
    print(f"Failed to drop views: {e}")

# Now loop over and execute all SQL files in views/
for sql_file in sorted(os.listdir(VIEWS_DIR)):
    if sql_file.endswith(".sql"):
        file_path = os.path.join(VIEWS_DIR, sql_file)
        print(f"Executing SQL file: {file_path}")
        try:
            with open(file_path, "r") as f:
                sql_content = f.read()
                cur.execute(sql_content)
                conn.commit()
            print(f"Executed successfully: {sql_file}")
        except Exception as e:
            conn.rollback()
            print(f"Failed to execute {sql_file}: {e}")

cur.close()
conn.close()
print("Finished dropping and recreating all views.")
