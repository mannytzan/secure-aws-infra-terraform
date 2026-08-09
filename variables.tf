variable "aws_region" {
  description = "AWS region in which to create resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix used for project resources."
  type        = string
  default     = "secure-aws-infra-terraform"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.0.0.0/16"
}
