def saldos_en_tránsito():
    query = """"
    SELECT fecha, saldo_flujos
    FROM spectrum_schema.transactions
    ORDER BY fecha;
    """
    return query