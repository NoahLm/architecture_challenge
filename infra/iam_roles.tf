# Glue IAM Role for Crawler, and attach policies of AWSGlueServiceRole
resource "aws_iam_role" "glue_crawler_role" {
  name = "glue-crawler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_crawler_role_attach" {
  role       = aws_iam_role.glue_crawler_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Glue IAM Role for Job, and attach policies of AWSGlueServiceRole
resource "aws_iam_role" "glue_job_role" {
  name = "glue-job-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_job_role_attach" {
  role       = aws_iam_role.glue_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Create IAM Role for Redshift Spectrum
# And attach policies of AmazonRedshift and personalized access to Glue Catalog and S3
resource "aws_iam_role" "redshift_role" {
  name = "redshift-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "spectrum_policy_attachment" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = aws_iam_policy.spectrum_policy.arn
}

resource "aws_iam_role_policy_attachment" "redshift_role_attachment" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}

