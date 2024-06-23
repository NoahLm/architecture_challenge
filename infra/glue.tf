# Glue Database
resource "aws_glue_catalog_database" "glue_db" {
  name = "noe-glue-db-banpay-challenge"
}

# Glue Crawler to catalog raw JSON data
resource "aws_glue_crawler" "glue_raw_data_crawler" {
  name          = "noe-glue-raw-data-crawler-by-challenge"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.glue_db.name
  s3_target {
    path = "s3://${aws_s3_bucket.raw_data.bucket}/raw/"
  }
  depends_on = [
    aws_iam_role_policy_attachment.glue_crawler_role_attach,
    aws_iam_role_policy.glue_crawler_policy
  ]
}

# Glue Crawler to catalog processed PARQUET data
resource "aws_glue_crawler" "glue_processed_data_date_crawler" {
  name          = "noe-glue-processed-data-date-crawler-by-challenge"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.glue_db.name
  s3_target {
    path = "s3://${aws_s3_bucket.processed_data.bucket}/dim/dates/"
  }
  depends_on = [
    aws_iam_role_policy_attachment.glue_crawler_role_attach,
    aws_iam_role_policy.glue_crawler_policy
  ]
}

# Glue Crawler to catalog processed PARQUET data
resource "aws_glue_crawler" "glue_processed_data_transactions_crawler" {
  name          = "noe-glue-processed-data-transactions-crawler-by-challenge"
  role          = aws_iam_role.glue_crawler_role.arn
  database_name = aws_glue_catalog_database.glue_db.name
  s3_target {
    path = "s3://${aws_s3_bucket.processed_data.bucket}/fact/transactions/"
  }
  depends_on = [
    aws_iam_role_policy_attachment.glue_crawler_role_attach,
    aws_iam_role_policy.glue_crawler_policy
  ]
}

# Glue Job to transform JSON to Parquet
resource "aws_glue_job" "json_to_parquet" {
  name     = "noe-json-to-parquet-by-challenge"
  role_arn = aws_iam_role.glue_job_role.arn
  command {
    script_location = "s3://${aws_s3_bucket.raw_data.bucket}/scripts/json_to_parquet.py"
    name            = "glueetl"
    python_version  = "3"
  }
  default_arguments = {
    "--TempDir"             = "s3://${aws_s3_bucket.raw_data.bucket}/tmp/"
    "--job-bookmark-option" = "job-bookmark-enable"
  }
  depends_on = [aws_iam_role_policy_attachment.glue_job_role_attach]
}