variable "name" {
  description = "Name prefix for IAM resources."
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket the role may access."
  type        = string
}

