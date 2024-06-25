from src.connections import run_query

def saldos_entrantes_y_salientes(start_date, end_date):
    query = f"""
    SELECT fecha, num_ingresos_hoy, num_egresos_hoy
    FROM spectrum_schema.transactions
    WHERE fecha BETWEEN '{start_date}' AND '{end_date}'
    ORDER BY fecha;
    """
    return run_query(query)