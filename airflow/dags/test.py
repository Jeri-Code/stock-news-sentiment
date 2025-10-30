from datetime import datetime
from airflow import DAG
from airflow.operators.empty import EmptyOperator

with DAG(
    dag_id="hello_world",          # name shown in Airflow UI
    start_date=datetime(2025, 1, 1),
    schedule_interval="@daily",    # runs once per day
    catchup=False,
    tags=["sns"],
):
    start = EmptyOperator(task_id="start")   # placeholder task
