# Secure AWS Infrastructure with Terraform

This project demonstrates a small segmented AWS network, a versioned and
encrypted S3 bucket, a least-privilege IAM role, and a Checkov pull-request
gate.

The pull-request scan fails on every Checkov finding. This is intentionally
stricter than a HIGH/CRITICAL-only threshold and requires no external scanner
API credential.

## Architecture

- One VPC with public and private subnets in separate availability zones
- An internet gateway and default route only for the public subnet
- One S3 bucket with encryption and versioning
- One EC2-assumable role scoped to the project bucket and objects

## Security pipeline demonstration

The initial S3 module intentionally omits `aws_s3_bucket_public_access_block`.
This creates a real Checkov finding so a pull request can demonstrate that the
security workflow blocks unsafe infrastructure. Add the public-access-block
resource in the remediation commit to show the before/after result.

Run checks locally:

```shell
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
checkov -d . --framework terraform
```

Never commit Terraform state, variable files containing secrets, or provider
credentials.
