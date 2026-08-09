# Secure AWS Infrastructure with Terraform

[![Terraform security scan](https://github.com/mannytzan/secure-aws-infra-terraform/actions/workflows/security-scan.yml/badge.svg)](https://github.com/mannytzan/secure-aws-infra-terraform/actions/workflows/security-scan.yml)

This project demonstrates a small segmented AWS network, a versioned and
encrypted S3 bucket, a least-privilege IAM role, and a Checkov pull-request
gate.

The pull-request scan blocks regressions of the S3 public-access block
(`CKV2_AWS_6`) and publishes a non-blocking report of all other findings. This
keeps the gate deterministic without an external scanner API credential while
preserving visibility into future hardening opportunities.

## Architecture

- One VPC with public and private subnets in separate availability zones
- An internet gateway and default route only for the public subnet
- One S3 bucket with encryption and versioning
- One EC2-assumable role scoped to the project bucket and objects

## Security pipeline demonstration

[PR #1](https://github.com/mannytzan/secure-aws-infra-terraform/pull/1)
preserves the complete before/after demonstration. The initial configuration
omitted `aws_s3_bucket_public_access_block`, producing a
[failed Checkov gate](https://github.com/mannytzan/secure-aws-infra-terraform/actions/runs/31291738520).
The remediation commit added all four public-access protections, after which
[the same gate passed](https://github.com/mannytzan/secure-aws-infra-terraform/actions/runs/31291786250).

## Terraform state

Terraform state is intentionally local for this demonstration rather than an
oversight. A production deployment should use a protected remote backend with
state locking, encryption, versioning, and tightly scoped access controls.

Run checks locally:

```shell
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
checkov -d . --framework terraform
```

Never commit Terraform state, variable files containing secrets, or provider
credentials.
