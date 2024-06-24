import pandas as pd
import streamlit as st
import redshift_connector

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