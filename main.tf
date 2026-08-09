provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  name                = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "s3" {
  source = "./modules/s3"

  bucket_name = "${var.project_name}-${data.aws_caller_identity.current.account_id}"
}

data "aws_caller_identity" "current" {}

module "iam" {
  source = "./modules/iam"

  name       = var.project_name
  bucket_arn = module.s3.bucket_arn
}

