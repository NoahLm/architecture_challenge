def saldos_entrantes_y_salientes():
    query = """
    SELECT fecha, num_ingresos_hoy, num_egresos_hoy
    FROM spectrum_schema.transactions
    ORDER BY fecha;
    """
    return query