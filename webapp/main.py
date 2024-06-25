import streamlit as st
import pandas
import numpy as np
from datetime import datetime

from queries.saldos_promedio import saldos_promedio
from queries.saldos_en_transito import saldos_en_tránsito
from queries.saldos_entrantes_y_salientes import saldos_entrantes_y_salientes
from queries.comparativa import comparativas_históricas
from queries.model_saldos_inversion import query_model_saldos_inversion

from src.connections import load_saldos_inversion_model
from src.models_predict import predict_saldo_inversion
from src.visualizations import linear_regression_plot

saldos_inversion_model = load_saldos_inversion_model()

st.title("Servicio de consultas financieras")

st.sidebar.header("Tipo de consulta")
option = st.sidebar.selectbox(
    "Selecciona una de las opciones:",
    (
        "Saldos promedio",
        "Saldos en tránsito",
        "Saldos entrantes y salientes",
        "Comparativas históricas de saldos",
        "Predecir Saldo de Inversion"    
    ),
)

if option == "Saldos promedio":
    st.header("Saldos Promedio")
    
    # User input for date range and columns
    start_date = st.date_input("Dia de Inicio", value=datetime(2023, 12, 25))
    end_date = st.date_input("Dia Final", value=datetime(2023, 12, 31))
    columns = st.multiselect("Selecciona las variables a promediar", ["Saldo_Inversion", "Saldo_Clientes", "Saldo_Flujos"])
    
    if columns:
        data = saldos_promedio(start_date, end_date, columns)
        data.columns = [f"Promedio_{col}" for col in columns]

        st.write("Saldos Promedio")
        st.write(data)
    else:
        st.warning("Por favor, selecciona al menos una columna.")

elif option == "Saldos en tránsito":
    st.header("Saldos en tránsito")

    start_date = st.date_input("Dia de Inicio", value=datetime(2023, 12, 25))
    end_date = st.date_input("Dia Final", value=datetime(2023, 12, 31))
    data = saldos_en_tránsito(start_date, end_date)
    data.columns = ['Fecha','Saldo_Flujos']

    st.write("Saldos en Tránsito")
    st.write(data)

elif option == "Saldos entrantes y salientes":
    start_date = st.date_input("Dia de Inicio", value=datetime(2023, 12, 25))
    end_date = st.date_input("Dia Final", value=datetime(2023, 12, 31))

    data = saldos_entrantes_y_salientes(start_date, end_date)
    data.columns = ['Fecha','Numero_Ingresos_Hoy', 'Numero_Egresos_Hoy']

    st.write("Saldos Entrantes y Salientes")
    st.write(data)

elif option == "Comparativas históricas de saldos":
    st.header("Comparativas históricas de saldos")

    start_date = st.date_input("Dia de Inicio", value=datetime(2023, 12, 25))
    end_date = st.date_input("Dia Final", value=datetime(2023, 12, 31))
    columns = st.multiselect("Selecciona las variables a comparar", ["Saldo_Inversion", "Saldo_Clientes", "Saldo_Flujos","Num_Ingresos_Hoy","Num_Egresos_Hoy"])

    if columns:
        data = comparativas_históricas(start_date, end_date, columns)
        data.columns = ['Fecha'] + columns

        st.write(f"Comparativa entre fechas {start_date},{end_date}")
        st.write(data)
    else:
        st.warning("Por favor, selecciona al menos una columna.")

elif option == "Predecir Saldo de Inversion":
    st.header("Predecir Saldo de Inversion en base a actividad de usuarios")

    start_date = st.date_input("Dia de Inicio", value=datetime(2023, 1, 1))
    end_date = st.date_input("Dia Final", value=datetime(2023, 12, 31))
    data = query_model_saldos_inversion(start_date, end_date)

    data.columns = ['Saldo_Inversion']

    X = np.array(range(len(data['Saldo_Inversion'])))
    y = data['Saldo_Inversion'].to_numpy()

    predicted_df = predict_saldo_inversion(saldos_inversion_model, X)

    st.write("Gráfico de Regresión Lineal")
    linear_regression_plot(X, y, predicted_df)
