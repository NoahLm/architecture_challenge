def saldos_promedio():
    query = """
    SELECT fecha, AVG(saldo_inversion) as avg_saldo_inversion, AVG(saldo_clientes) as avg_saldo_clientes
    FROM spectrum_schema.transactions
    GROUP BY fecha
    ORDER BY fecha LIMIT 15;
    """
    return query