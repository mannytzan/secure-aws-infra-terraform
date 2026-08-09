output "role_arn" {
  description = "ARN of the application IAM role."
  value       = aws_iam_role.application.arn
}

output "policy_arn" {
  description = "ARN of the least-privilege bucket policy."
  value       = aws_iam_policy.bucket_access.arn
}

