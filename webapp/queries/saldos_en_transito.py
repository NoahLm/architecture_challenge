from src.connections import run_query

def saldos_en_tránsito():
    query = """
    SELECT fecha, saldo_flujos
    FROM spectrum_schema.transactions
    ORDER BY fecha LIMIT 15;
    """
    return run_query(query)