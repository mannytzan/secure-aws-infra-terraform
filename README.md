# Secure AWS Infrastructure with Terraform

[![Terraform security scan](https://github.com/mannytzan/secure-aws-infra-terraform/actions/workflows/security-scan.yml/badge.svg)](https://github.com/mannytzan/secure-aws-infra-terraform/actions/workflows/security-scan.yml)

## Why this exists

Public buckets, over-permissioned IAM policies, and other infrastructure
misconfigurations can reach production when nothing checks Terraform before
merge. This is a reference implementation of that gate: fork it and point it at
your own Terraform to adopt the same pattern.

## Proof

- Initial full scan: **26 checks passed and 9 failed**
- IAM least-privilege verification: **3 of 3 checks passed**
- Before remediation: [`CKV2_AWS_6` blocked the pull request](https://github.com/mannytzan/secure-aws-infra-terraform/actions/runs/31291738520)
- After remediation: [the same Checkov gate passed](https://github.com/mannytzan/secure-aws-infra-terraform/actions/runs/31291786250)

This is real CI output, not a staged example. See
[PR #1](https://github.com/mannytzan/secure-aws-infra-terraform/pull/1) for the
full before/after.

## Architecture

- One VPC with public and private subnets in separate availability zones
- An internet gateway and default route only for the public subnet
- One S3 bucket with encryption and versioning
- One EC2-assumable role scoped to the project bucket and objects
- A required Checkov pull-request gate plus a non-blocking full findings report

## Security pipeline demonstration

See [Proof](#proof) and
[PR #1](https://github.com/mannytzan/secure-aws-infra-terraform/pull/1) for the
failed public-access check and the passing remediation.

## Use this in your own repo

1. Fork this repository, or copy `modules/` and
   `.github/workflows/security-scan.yml` into your Terraform project.
2. Call the modules from your root `main.tf`, or update the workflow's
   `directory` input to the folder containing your Terraform configuration.
3. Change `aws_region`, `project_name`, CIDR ranges, and bucket naming for your
   AWS account. S3 bucket names must remain globally unique.
4. Run the local checks below before opening a pull request, then make the
   Checkov job a required status check in your branch protection rules.

## Terraform state

Terraform state is intentionally local for this demonstration rather than an
oversight. A production deployment should use a protected remote backend with
state locking, encryption, versioning, and tightly scoped access controls.

## Local validation

```shell
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
checkov -d . --framework terraform
```

Never commit Terraform state, variable files containing secrets, or provider
credentials.
