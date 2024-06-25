import sys
from pyspark.sql import SparkSession
from pyspark.sql.functions import col as spark_col, explode, dayofmonth, month, year, dayofweek, date_format, quarter, weekofyear, dayofyear, to_date

def main():
    spark = SparkSession.builder.appName("json_to_parquet").getOrCreate()
    
    df = spark.read.option("multiline", "true").json("s3://noe-raw-data-by-challenge/raw/data.json")

    # The structure has an outer field 'rows' containing the data
    df = df.select(explode(spark_col("rows")).alias("row")).select("row.*")

    # Defines Fecha as date format for schema
    df = df.withColumn("Fecha", to_date(df["Fecha"], "yyyy-MM-dd"))

    # Transform to Facts and Dimensions, splitting the original schema
    facts_df = df.select("Fecha", "Saldo_Inversion", "saldo_clientes", "num_ingresos_hoy", "num_egresos_hoy", "Saldo_Flujos")

    dims_df = df.select(
        "Fecha",        
        dayofmonth("Fecha").alias("dia_del_mes"),
        month("Fecha").alias("mes"),
        year("Fecha").alias("año"),
        dayofweek("Fecha").alias("dia_semana")
    ).withColumn("nombre_del_mes", date_format(spark_col("Fecha"), "MMMM")) \
     .withColumn("trimestre", quarter(spark_col("Fecha"))) \
     .withColumn("semana_del_año", weekofyear(spark_col("Fecha"))) \
     .withColumn("dia_del_año", dayofyear(spark_col("Fecha"))) \
     .withColumn("entre_semana", spark_col("dia_semana").isin([2, 3, 4, 5, 6])) \
     .withColumn("nombre_del_dia", date_format(spark_col("Fecha"), "EEEE"))

    # Write to Parquet
    facts_df.write.mode("overwrite").parquet("s3://noe-processed-data-by-challenge/fact/transactions/")
    dims_df.write.mode("overwrite").parquet("s3://noe-processed-data-by-challenge/dim/dates/")

if __name__ == "__main__":
    main()