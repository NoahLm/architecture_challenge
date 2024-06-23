from sqlalchemy import create_engine
import pandas as pd
import streamlit as st

# Database connection function
def get_connection():
    user = st.secrets["user"]
    password = st.secrets["password"]
    host = st.secrets["host"]
    port = st.secrets["port"]
    database = st.secrets["database"]
    
    conn_str = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
    engine = create_engine(conn_str)
    return engine.connect()

# Function to execute queries
def run_query(query):
    conn = get_connection()
    return pd.read_sql(query, conn)