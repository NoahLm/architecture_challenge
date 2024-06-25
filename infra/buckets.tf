#Create S3 Buckets
resource "aws_s3_bucket" "raw_data" {
  bucket = "noe-raw-data-by-challenge"
}

resource "aws_s3_bucket" "processed_data" {
  bucket = "noe-processed-data-by-challenge"
}

# Upload raw data and etl files to the S3 buckets
resource "aws_s3_bucket_object" "raw_data_json" {
  bucket = aws_s3_bucket.raw_data.bucket
  key    = "raw/data.json"
  source = var.json_route
  acl    = "private"
}

resource "aws_s3_bucket_object" "glue_etl_script" {
  bucket = aws_s3_bucket.raw_data.bucket
  key    = "scripts/json_to_parquet.py"
  source = var.scripts_route
  acl    = "private"
}

# Ownership controls for the S3 buckets
resource "aws_s3_bucket_ownership_controls" "raw_data_ownership" {
  bucket = aws_s3_bucket.raw_data.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_ownership_controls" "processed_data_ownership" {
  bucket = aws_s3_bucket.processed_data.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block public access settings for the S3 buckets
resource "aws_s3_bucket_public_access_block" "raw_data_block" {
  bucket                  = aws_s3_bucket.raw_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "processed_data_block" {
  bucket                  = aws_s3_bucket.processed_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for the buckets, therefore files
resource "aws_s3_bucket_versioning" "raw_data_versioning" {
  bucket = aws_s3_bucket.raw_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "processed_data_versioning" {
  bucket = aws_s3_bucket.processed_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Set ACL for the S3 buckets
resource "aws_s3_bucket_acl" "raw_data_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.raw_data_block,
    aws_s3_bucket_ownership_controls.raw_data_ownership,
  ]

  bucket = aws_s3_bucket.raw_data.id
  acl    = "private"
}

resource "aws_s3_bucket_acl" "processed_data_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.processed_data_block,
    aws_s3_bucket_ownership_controls.processed_data_ownership,
  ]

  bucket = aws_s3_bucket.processed_data.id
  acl    = "private"
}