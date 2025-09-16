#!/bin/bash
set -e  # stop on first error

echo "Initializing Airflow DB..."
airflow db init

echo "Creating connections..."
airflow connections add postgres_public \
    --conn-type postgres \
    --conn-host postgres \
    --conn-schema dev_dwh \
    --conn-login postgres \
    --conn-password postgres_pass \
    --conn-port 5432

airflow connections add postgres_odoo \
    --conn-type postgres \
    --conn-host odoo_host \
    --conn-schema odoo_db \
    --conn-login odoo_user \
    --conn-password odoo_pass \
    --conn-port 5432

echo "Setting Airflow variables..."
airflow variables set stg_source_system public

echo "Initialization done."
