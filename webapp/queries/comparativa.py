def comparativas_históricas():
    query = """
    SELECT fecha, saldo_inversion
    FROM spectrum_schema.transactions
    ORDER BY fecha LIMIT 15;
    """
    return query