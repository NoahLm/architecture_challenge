import streamlit as st

from queries.saldos_promedio import saldos_promedio
from queries.saldos_en_transito import saldos_en_tránsito
from queries.saldos_entrantes_y_salientes import saldos_entrantes_y_salientes
from queries.comparativa import comparativas_históricas

from src.connections import run_query

# Streamlit App
st.title("Redshift Spectrum Data Viewer")

st.sidebar.header("Queries")
option = st.sidebar.selectbox(
    "Select Query",
    (
        "Saldos promedio",
        "Saldos en tránsito",
        "Saldos entrantes y salientes",
        "Comparativas históricas de saldos de inversión",
    ),
)

if option == "Saldos promedio":
    query = saldos_promedio()
    data = run_query(query)
    st.write("Saldos Promedio")
    st.write(data)

elif option == "Saldos en tránsito":
    query = saldos_en_tránsito()
    data = run_query(query)
    st.write("Saldos en Tránsito")
    st.write(data)

elif option == "Saldos entrantes y salientes":
    query = saldos_entrantes_y_salientes()
    data = run_query(query)
    st.write("Saldos Entrantes y Salientes")
    st.write(data)

elif option == "Comparativas históricas de saldos de inversión":
    query = comparativas_históricas()
    data = run_query(query)
    st.write("Comparativas Históricas de Saldos de Inversión")
    st.write(data)