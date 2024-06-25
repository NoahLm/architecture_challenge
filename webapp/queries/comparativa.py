from src.connections import run_query

def comparativas_históricas(start_date, end_date, columns):
    columns_comps = ", ".join([f"{col}" for col in columns]) # Formats to SQL the selected columns for the query
    query = f"""
    SELECT fecha, {columns_comps}
    FROM spectrum_schema.transactions
    WHERE fecha IN ('{start_date}', '{end_date}')
    ORDER BY fecha;
    """
    return run_query(query)