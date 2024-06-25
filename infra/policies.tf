# Add a bucket policy to allow access for the IAM roles
resource "aws_s3_bucket_policy" "raw_data_policy" {
  bucket = aws_s3_bucket.raw_data.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = [
            aws_iam_role.glue_crawler_role.arn,
            aws_iam_role.glue_job_role.arn
          ]
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.raw_data.arn}",
          "${aws_s3_bucket.raw_data.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "processed_data_policy" {
  bucket = aws_s3_bucket.processed_data.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.glue_job_role.arn
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.processed_data.arn}",
          "${aws_s3_bucket.processed_data.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Principal = {
          AWS = "${aws_iam_role.redshift_role.arn}"
        },
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.processed_data.arn}",
          "${aws_s3_bucket.processed_data.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "glue_crawler_policy" {
  name = "glue-crawler-policy"
  role = aws_iam_role.glue_crawler_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.raw_data.arn}",
          "${aws_s3_bucket.raw_data.arn}/*",
          "${aws_s3_bucket.processed_data.arn}",
          "${aws_s3_bucket.processed_data.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetBucketAcl"
        ],
        Resource = [
          "${aws_s3_bucket.raw_data.arn}",
          "${aws_s3_bucket.processed_data.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "glue_job_policy" {
  name = "glue-job-policy"
  role = aws_iam_role.glue_job_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.raw_data.arn}",
          "${aws_s3_bucket.raw_data.arn}/*",
          "${aws_s3_bucket.processed_data.arn}",
          "${aws_s3_bucket.processed_data.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:*"
        ],
        Resource = "*"
      },
            {
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "spectrum_policy" {
  name        = "spectrum_policy"
  description = "Policy to allow Redshift Spectrum and Glue access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::processed_data",
          "arn:aws:s3:::processed_data/*"
        ]
      },
      {
        Action = [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetTableVersion",
          "glue:GetTableVersions",
          "glue:CreateDatabase",
          "glue:CreateTable",
          "glue:GetPartitions"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action = [
          "redshift:GetClusterCredentials",
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
