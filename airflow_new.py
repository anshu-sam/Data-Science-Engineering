'''
pip3 install apache-airflow[gcp]
'''
from airflow import models
from datetime import datetime, timedelta
from airflow.contrib.operators.dataflow_operator import DataFlowPythonOperator

default_args = {
    'owner': 'Airflow',
    'start_date': datetime(2020, 12, 24),
    'retries': 0,
    'retry_delay': timedelta(seconds=50),
	'dataflow_default_options': {
        'project': 'gcpsample-454115',
        'region': 'us-central1',
		'runner': 'DataflowRunner'
    }
}

with models.DAG('food_orders_dag',
         default_args=default_args,
         schedule_interval='@daily',
         catchup=False) as dag:
    
    t1 = DataFlowPythonOperator(
        task_id='beamtask',
        py_file='gs://us-central1-food-orders-dag-45c92500-bucket/gcp_pipeline_dataflow.py',
        options={'input','gs://daily_food_orders_bq/food_daily.csv'}
    )