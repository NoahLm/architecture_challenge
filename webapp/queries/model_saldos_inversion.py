from src.connections import run_query

def query_model_saldos_inversion(start_date, end_date):
    query = f"""
    SELECT Saldo_Inversion
    FROM spectrum_schema.transactions
    WHERE fecha BETWEEN '{start_date}' AND '{end_date}';
    """
    return run_query(query)