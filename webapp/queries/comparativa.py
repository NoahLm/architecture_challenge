def comparativas_históricas():
    query = """
    SELECT fecha, saldo_inversion
    FROM spectrum_schema.transactions
    ORDER BY fecha;
    """
    return query