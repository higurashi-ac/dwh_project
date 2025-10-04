#!/bin/bash
# create_airflow_user.sh

# Wait for Airflow DB to be ready
echo "Waiting for Airflow DB..."
sleep 10  # adjust if needed

# Create Airflow user
docker exec -it airflow-webserver airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin || true

echo "Airflow user creation finished."
