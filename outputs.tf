output "vpc_id" {
  description = "ID of the project VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet."
  value       = module.vpc.private_subnet_id
}

output "bucket_name" {
  description = "Name of the project S3 bucket."
  value       = module.s3.bucket_name
}

output "iam_role_arn" {
  description = "ARN of the least-privilege application role."
  value       = module.iam.role_arn
}

