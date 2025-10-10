CREATE SCHEMA IF NOT EXISTS stg;
CREATE SCHEMA IF NOT EXISTS dwh;
CREATE SCHEMA IF NOT EXISTS ctrl;

CREATE TABLE IF NOT EXISTS ctrl.etl_audit (
    audit_id BIGSERIAL PRIMARY KEY,
    dag_id TEXT NOT NULL,
    task_id TEXT NOT NULL,
    table_name TEXT NOT NULL,
    status TEXT,
    rows_affected BIGINT,
    started_at TIMESTAMP DEFAULT now(),
    finished_at TIMESTAMP,
    duration_seconds NUMERIC,
    error_message TEXT
);
