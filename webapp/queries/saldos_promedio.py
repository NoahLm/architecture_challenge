from src.connections import run_query
import streamlit as st

def saldos_promedio(start_date, end_date, columns):
    columns_avg = ", ".join([f"AVG({col}) as avg_{col}" for col in columns])
    query = f"""
    SELECT {columns_avg}
    FROM spectrum_schema.transactions
    WHERE fecha BETWEEN '{start_date}' AND '{end_date}';
    """

    return run_query(query)
