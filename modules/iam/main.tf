resource "aws_iam_role" "application" {
  name = "${var.name}-application"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "bucket_access" {
  name        = "${var.name}-bucket-access"
  description = "Least-privilege read and write access to the project bucket."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListProjectBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = var.bucket_arn
      },
      {
        Sid      = "ReadWriteProjectObjects"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = "${var.bucket_arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bucket_access" {
  role       = aws_iam_role.application.name
  policy_arn = aws_iam_policy.bucket_access.arn
}

