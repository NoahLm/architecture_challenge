import pandas as pd
import streamlit as st
import redshift_connector
import boto3
import joblib
import io

def get_connection():
    conn = redshift_connector.connect(
        host=st.secrets["host"],
        database=st.secrets["database"],
        user=st.secrets["user"],
        password=st.secrets["password"],
        port=int(st.secrets["port"])
    )
    return conn

# Function to execute queries
def run_query(query):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    conn.close()
    # Convert the result to a pandas DataFrame
    df = pd.DataFrame(result)
    return df

# Load the model from S3
def load_saldos_inversion_model():
    bucket_name = st.secrets["processed_data_bucket_name"]
    model_file = st.secrets["saldo_inversion_model_path"]
    s3 = boto3.client('s3')
    response = s3.get_object(Bucket=bucket_name, Key=model_file)
    model = joblib.load(io.BytesIO(response['Body'].read()))
    return model

