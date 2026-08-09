# Secure AWS Infrastructure with Terraform

[![Terraform security scan](https://github.com/mannytzan/secure-aws-infra-terraform/actions/workflows/security-scan.yml/badge.svg)](https://github.com/mannytzan/secure-aws-infra-terraform/actions/workflows/security-scan.yml)

## Why this exists

I built this because I was tired of Terraform misconfigurations getting through
review simply because nothing could stop them before merge. A public S3 bucket
or an overly broad IAM policy should fail in CI, not turn into cleanup work
after a deploy.

This is a reference implementation of that gate: fork it and point it at your
own Terraform to adopt the same pattern.

## Proof

- Initial full scan: **26 checks passed and 9 failed**
- IAM least-privilege verification: **3 of 3 checks passed**
- Before remediation: [`CKV2_AWS_6` blocked the pull request](https://github.com/mannytzan/secure-aws-infra-terraform/actions/runs/31291738520)
- After remediation: [the same Checkov gate passed](https://github.com/mannytzan/secure-aws-infra-terraform/actions/runs/31291786250)

These results came from the actual pull-request workflow, not copied terminal
output. [PR #1](https://github.com/mannytzan/secure-aws-infra-terraform/pull/1)
has the full before/after.

## Architecture

The stack stays small on purpose. It creates one VPC with a public subnet and a
private subnet in separate availability zones. Only the public subnet gets a
default route through the internet gateway.

The S3 bucket has encryption, versioning, and all four public-access blocks.
An EC2-assumable IAM role can list that bucket and read or write its objects;
it does not get wildcard S3 access. The pull-request workflow enforces the S3
public-access check and also publishes the rest of the Checkov findings without
blocking on them.

## Security pipeline demonstration

See [Proof](#proof) and
[PR #1](https://github.com/mannytzan/secure-aws-infra-terraform/pull/1) for the
failed public-access check and the passing remediation.

## Use this in your own repo

If you want the same gate in another Terraform repo, the quickest route is to
reuse the pieces here and adjust them to fit the account.

1. Fork this repository, or copy `modules/` and
   `.github/workflows/security-scan.yml` into your Terraform project.
2. Call the modules from your root `main.tf`, or update the workflow's
   `directory` input to the folder containing your Terraform configuration.
3. Change `aws_region`, `project_name`, CIDR ranges, and bucket naming for your
   AWS account. S3 bucket names must remain globally unique.
4. Run the local checks below before opening a pull request, then make the
   Checkov job a required status check in your branch protection rules.

## Terraform state

State is local here on purpose. This repo is still a reference implementation,
so adding a remote backend would imply deployment decisions that it does not
make yet. For a real environment, I would use a protected remote backend with
locking, encryption, versioning, and tightly scoped access.

## Local validation

```shell
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
checkov -d . --framework terraform
```

Never commit Terraform state, variable files containing secrets, or provider
credentials.
