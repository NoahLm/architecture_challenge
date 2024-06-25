from src.connections import run_query

def saldos_en_tránsito(start_date,end_date):
    query = f"""
    SELECT fecha, saldo_flujos
    FROM spectrum_schema.transactions
    WHERE fecha BETWEEN '{start_date}' AND '{end_date}'
    ORDER BY fecha;
    """
    return run_query(query)